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

[Peer]
PublicKey = +wWwgGASvN7AX6SIsWu9fxeQvaDk8THI/AWnJ41Zzx8=
AllowedIPs = 0.0.0.0/0
Endpoint = 51.210.63.162:51820
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
