# Server Service Setup

Set up whatever services you want, and comment out the ones you don't. Then when you're good to go:

```
docker-compose up -d
docker attach server_vpn_1
# Input VPN username and password
# ctrl-p ctrl-q to detach
```

## Transmission

- Edit `transmission/settings.json`
  - Change the `rpc-password` field to something good

## More Info

This is the mastermind container: https://hub.docker.com/r/dperson/openvpn-client

If you want to add more services, look into that page. You'll probably just need to add a new container then link it to the nginx proxy.
