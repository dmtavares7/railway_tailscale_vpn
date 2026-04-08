#!/bin/sh

./tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &

until ./tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${TAILSCALE_HOSTNAME} --advertise-exit-node --accept-routes --reset
do
    sleep 0.1
done

# Proxy TCP via SOCKS5 para os bancos TOTVS
socat TCP-LISTEN:1433,fork,reuseaddr SOCKS4A:localhost:4.228.59.130:1433,socksport=1055 &
socat TCP-LISTEN:37000,fork,reuseaddr SOCKS4A:localhost:177.136.10.251:37000,socksport=1055 &
socat TCP-LISTEN:38000,fork,reuseaddr SOCKS4A:localhost:177.136.10.31:38000,socksport=1055 &

sleep infinity
