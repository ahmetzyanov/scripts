#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a name"
  exit 1
fi

wg-quick down wg0

NAME=$1
ADDRESS=$(cat address)

wg genkey | tee $NAME.key | wg pubkey > $NAME.pub

PRIVATE=$(cat $NAME.key)
PUBLIC=$(cat $NAME.pub)

cat > $NAME.conf << EOF
[Interface]
PrivateKey = $PRIVATE
Address = 10.255.255.$ADDRESS/24
DNS = 1.1.1.1

[Peer]
PublicKey = <place_your_server_pubkey_here>
AllowedIPs = 0.0.0.0/0
Endpoint = <place_your_public_ip_here>:<port>
PersistentKeepalive = 25
EOF

cat >> /etc/wireguard/wg0.conf << EOF
[Peer]
PublicKey = $PUBLIC
AllowedIPs = 10.255.255.$ADDRESS/32
EOF

ADDRESS=$((ADDRESS+1))
echo $ADDRESS > address

wg-quick up wg0
