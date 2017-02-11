FROM nginx:1.11

COPY start.sh /
COPY nginx.conf /etc/nginx/

RUN openssl dhparam -dsaparam -out /etc/ssl/private/dhparam.pem 4096

CMD /start.sh
