echo sleep 3
sleep 3

nginx_conf=/etc/nginx/nginx-osc.conf

if [ -f "$nginx_conf"]; then
  echo "$nginx_conf found."
  cp "$nginx_conf" /etc/nginx/nginx.conf
fi

echo Firing up nginx in the background.
nginx -g 'daemon off;'
