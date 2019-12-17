# FROM envoyproxy/envoy:v1.12.2

# COPY conf/simple.yaml /etc/envoy
# COPY conf/simple_change_timeout.yaml /etc/envoy
# COPY conf/simple_retry.yaml /etc/envoy

# CMD /usr/local/bin/envoy --v2-config-only -l $loglevel -c /etc/envoy/envoy.yaml

FROM envoyproxy/envoy-dev:latest

COPY conf/*.yaml /etc/envoy/
ADD lib/mylibrary.lua /lib/mylibrary.lua
EXPOSE 80

CMD /usr/local/bin/envoy -c /etc/envoy/proxy.yaml -l debug --service-cluster proxy
# CMD /usr/local/bin/envoy -c /etc/envoy/simple.yaml -l debug --service-cluster proxy