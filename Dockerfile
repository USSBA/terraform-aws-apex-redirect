FROM nginx:stable-alpine
RUN apk add --update --no-cache python3 python3-dev py3-pip bash \
  && pip3 install --upgrade pip awscli \
  && rm -rf /var/cache/apk/*
COPY --chown=root:root docker-entrypoint.sh /usr/bin/entrypoint
RUN chmod 500 /usr/bin/entrypoint
ENTRYPOINT ["entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
