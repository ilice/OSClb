echo sleep 3
sleep 3

echo build starting nginx config

echo replacing ___my.example.com___/$MY_DOMAIN_NAME
# Put your domain name into the nginx reverse proxy config.
sed -i "s/___my.example.com___/$MY_DOMAIN_NAME/g" /etc/nginx/nginx.conf

echo replacing ___LETSENCRYPT_IP___/$LETSENCRYPT_PORT_80_TCP_ADDR
sed -i "s/___LETSENCRYPT_IP___/$LETSENCRYPT_PORT_80_TCP_ADDR/g" /etc/nginx/nginx.conf

echo replacing ___LETSENCRYPT_PORT___/$LETSENCRYPT_PORT_80_TCP_PORT
sed -i "s/___LETSENCRYPT_PORT___/$LETSENCRYPT_PORT_80_TCP_PORT/g" /etc/nginx/nginx.conf

echo replacing ___APPLICATION_IP___/$APP_PORT_80_TCP_ADDR
# Add your app's container IP and port into config
sed -i "s/___APPLICATION_IP___/$APP_PORT_80_TCP_ADDR/g" /etc/nginx/nginx.conf

echo replacing ___APPLICATION_PORT___/$APP_PORT_80_TCP_PORT
sed -i "s/___APPLICATION_PORT___/$APP_PORT_80_TCP_PORT/g" /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf
echo .

echo Firing up nginx.
nginx

echo Check user has specified domain name
if [ -z "$MY_DOMAIN_NAME" ]; then
    echo "Need to set MY_DOMAIN_NAME (to a letsencrypt-registered name)."
    # exit 1
fi

#go!
kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf

echo Firing up nginx in the background.
nginx -g 'daemon off;'
