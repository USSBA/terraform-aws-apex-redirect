#!/bin/bash
set -eo pipefail

HAS_CONFIG_ERR=0
if [[ -z "${REDIRECT_FQDN}" ]]; then
  echo "Missing Required Environment Variable: REDIRECT_FQDN"
  HAS_CONFIG_ERR=1
fi
if [[ -z "${HSTS_HEADER_VALUE}" ]]; then
  echo "Missing Required Environment Variable: HSTS_HEADER_VALUE"
  HAS_CONFIG_ERR=1
fi
if [[ -z "${AWS_S3_BUCKET_NAME}" ]]; then
  echo "Missing Required Environment Variable: AWS_S3_BUCKET_NAME"
  HAS_CONFIG_ERR=1
fi
if [[ -z "${AWS_S3_KEY_FULLCHAIN_PEM}" ]]; then
  echo "Missing Required Environment Variable: AWS_S3_KEY_FULLCHAIN_PEM"
  HAS_CONFIG_ERR=1
fi
if [[ -z "${AWS_S3_KEY_PRIVATEKEY_PEM}" ]]; then
  echo "Missing Required Environment Variable: AWS_S3_KEY_PRIVATEKEY_PEM"
  HAS_CONFIG_ERR=1
fi
if [[ HAS_CONFIG_ERR == 1 ]]; then
  exit 1
fi

# if keys begin with a forward slash then we need to remove it
AWS_S3_KEY_FULLCHAIN_PEM=`echo $AWS_S3_KEY_FULLCHAIN_PEM | sed -e 's|^\/||'`
AWS_S3_KEY_PRIVATEKEY_PEM=`echo $AWS_S3_KEY_PRIVATEKEY_PEM | sed -e 's|^\/||'`


mkdir -p /certs
aws s3 cp "s3://${AWS_S3_BUCKET_NAME}/${AWS_S3_KEY_FULLCHAIN_PEM}" /certs/certificate.pem
aws s3 cp "s3://${AWS_S3_BUCKET_NAME}/${AWS_S3_KEY_PRIVATEKEY_PEM}" /certs/privatekey.pem
chown -R nginx:nginx /certs/
chmod 0600 /certs/*

echo "user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;
include /usr/share/nginx/modules/*.conf;
events { worker_connections 1024; }
http {
  # SSL
  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  ssl_session_tickets off;

  # modern configuration
  ssl_protocols TLSv1.2;
  ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS;
  ssl_prefer_server_ciphers on;

  # OCSP Stapling
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 208.67.222.222 208.67.220.220 valid=60s;
  resolver_timeout 2s;

  server {
    listen 80; server_tokens off;
    return 301 https://${REDIRECT_FQDN}\$request_uri;
  }

  server {
    listen 443 ssl http2;
    add_header Strict-Transport-Security \"${HSTS_HEADER_VALUE}\";
    return 301 https://${REDIRECT_FQDN}\$request_uri;

    ssl_certificate       /certs/certificate.pem;
    ssl_certificate_key   /certs/privatekey.pem;
    ssl_protocols         TLSv1.1 TLSv1.2;
    ssl_ciphers           HIGH:!aNULL:!MD5;
  }
}" > /etc/nginx/nginx.conf

exec "$@"
