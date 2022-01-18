# Server Service Setup

1. Set up whatever services you want, and comment out the ones you don't
2. Create and edit `.env` and add your VPN username and password, like so: `VPN_AUTH=username;password`
3. Download a `.ovpn` file for your VPN, and put it in `./vpn/` (along with the `.pem` and `.crt` files)
3. `docker-compose up -d`

## Transmission

- Edit `transmission/settings.json`
  - Change the `rpc-password` field to something good

## More Info

This is the mastermind container: https://hub.docker.com/r/dperson/openvpn-client

If you want to add more services, look into that page. You'll probably just need to add a new container then link it to the nginx proxy.
