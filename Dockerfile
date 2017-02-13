FROM nginx:1.11

COPY start.sh /
RUN chmod +x /start.sh
COPY nginx.conf /etc/nginx/
ADD src/ /var/www

RUN openssl dhparam -dsaparam -out /etc/ssl/private/dhparam.pem 4096

CMD /start.sh
