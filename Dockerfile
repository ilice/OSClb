FROM nginx:1.11

COPY start.sh /
RUN chmod +x /start.sh
COPY osc.conf /etc/nginx/conf.d/
COPY osc-secure.conf /etc/nginx/

RUN openssl dhparam -dsaparam -out /etc/ssl/private/dhparam.pem 4096

CMD /start.sh
