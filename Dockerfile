FROM alpine:3.24.0

RUN apk add --no-cache libqrencode-tools busybox-extras tini

COPY cgi-bin/qr /www/cgi-bin/qr
RUN chmod +x /www/cgi-bin/qr

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--", "httpd", "-f", "-p", "8080", "-h", "/www"]
