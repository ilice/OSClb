FROM nginx:1.11

COPY start.sh /
RUN chmod +x /start.sh
COPY nginx.conf /etc/nginx/
ADD src/ /var/www

CMD /start.sh
