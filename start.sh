echo sleep 3
sleep 3

echo build starting nginx config

echo replacing __alowedIP__/$ALLOWED_IP
echo replacing __www.opensmartcountry.com__/$OPENSMARTCOUNTRY_DOMAIN
echo replacing __kibana.opensmartcountry.com__/$KIBANA_OPENSMARTCOUNTRY_DOMAIN
echo replacing __elastic.opensmartcountry.com__/$ELASTIC_OPENSMARTCOUNTRY_DOMAIN
echo replacing __jupyter.opensmartcountry.com__/$JUPYTER_OPENSMARTCOUNTRY_DOMAIN

# Put your domain name into the nginx reverse proxy config.
sed -i "s/__www.opensmartcountry.com__/$OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/conf.d/osc.conf
sed -i "s/__kibana.opensmartcountry.com__/$KIBANA_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/conf.d/osc.conf
sed -i "s/__elastic.opensmartcountry.com__/$ELASTIC_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/conf.d/osc.conf
sed -i "s/__jupyter.opensmartcountry.com__/$JUPYTER_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/conf.d/osc.conf

cat /etc/nginx/conf.d/osc.conf
echo .
echo Firing up nginx in the background.
nginx

# Check user has specified domain name
if [ -z "$OPENSMARTCOUNTRY_DOMAIN" ]; then
  echo "WARNING - Need to set OPENSMARTCOUNTRY_DOMAIN (to a letsencrypt-registered name). Stating DEVELOPMENT mode"

  #go dev mode!
  kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
  cp /etc/nginx/osc-development.conf /etc/nginx/conf.d/osc.conf

  cat /etc/nginx/conf.d/osc.conf
  echo .
  echo Firing up development nginx in the background.

  nginx -g 'daemon off;'

else

  if [ -z "$KIBANA_OPENSMARTCOUNTRY_DOMAIN" ]; then
      echo "Need to set KIBANA_OPENSMARTCOUNTRY_DOMAIN (to a letsencrypt-registered name)."
      exit 1
  fi

  if [ -z "$ELASTIC_OPENSMARTCOUNTRY_DOMAIN" ]; then
      echo "Need to set ELASTIC_OPENSMARTCOUNTRY_DOMAIN (to a letsencrypt-registered name)."
      exit 1
  fi

  if [ -z "$JUPYTER_OPENSMARTCOUNTRY_DOMAIN" ]; then
      echo "Need to set JUPYTER_OPENSMARTCOUNTRY_DOMAIN (to a letsencrypt-registered name)."
      exit 1
  fi
  # This bit waits until the letsencrypt container has done its thing.
  # We see the changes here bceause there's a docker volume mapped.
  echo Waiting for folder /etc/letsencrypt/live/$OPENSMARTCOUNTRY_DOMAIN to exist
  while [ ! -d /etc/letsencrypt/live/$OPENSMARTCOUNTRY_DOMAIN ] ;
  do
      sleep 2
  done

  while [ ! -f /etc/letsencrypt/live/$OPENSMARTCOUNTRY_DOMAIN/fullchain.pem ] ;
  do
      echo Waiting for file fullchain.pem to exist
      sleep 2
  done

  while [ ! -f /etc/letsencrypt/live/$OPENSMARTCOUNTRY_DOMAIN/privkey.pem ] ;
  do
    echo Waiting for file privkey.pem to exist
    sleep 2
  done

  echo replacing __www.opensmartcountry.com__/$OPENSMARTCOUNTRY_DOMAIN

  sed -i "s/__www.opensmartcountry.com__/$OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/osc-secure.conf


  echo replacing __kibana.opensmartcountry.com__/$KIBANA_OPENSMARTCOUNTRY_DOMAIN
  echo replacing __elastic.opensmartcountry.com__/$ELASTIC_OPENSMARTCOUNTRY_DOMAIN
  echo replacing __jupyter.opensmartcountry.com__/$JUPITER_OPENSMARTCOUNTRY_DOMAIN

  # Put your domain name into the nginx reverse proxy config.

  sed -i "s/__kibana.opensmartcountry.com__/$KIBANA_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/osc-secure.conf
  sed -i "s/__elastic.opensmartcountry.com__/$ELASTIC_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/osc-secure.conf
  sed -i "s/__jupyter.opensmartcountry.com__/$JUPYTER_OPENSMARTCOUNTRY_DOMAIN/g" /etc/nginx/osc-secure.conf

  #go!
  kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
  cp /etc/nginx/osc-secure.conf /etc/nginx/conf.d/osc.conf

  cat /etc/nginx/conf.d/osc.conf
  echo .
  echo Firing up nginx in the background.

  nginx -g 'daemon off;'
fi
