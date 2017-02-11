FROM nginx:1.11

COPY start.sh /
COPY nginx.conf /etc/nginx/

openssl dhparam -out /etc/ssl/private/dhparam.pem 4096

CMD /start.sh
