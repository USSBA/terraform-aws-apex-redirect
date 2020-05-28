#!/bin/bash
set -eo pipefail


echo "user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;
include /usr/share/nginx/modules/*.conf;
events { worker_connections 1024; }
http {
  server {
    listen 80; server_tokens off;
    return 301 https://${REDIRECT_FQDN}\$request_uri;
  }
  server {
    listen 1234; server_tokens off;
    location = /aws-hc-nginx { stub_status on; }
    location / { return 500; }
  }
}" > /etc/nginx/nginx.conf

exec "$@"
