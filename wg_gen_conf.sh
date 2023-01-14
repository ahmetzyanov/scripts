#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a name"
  exit 1
fi

NAME=$1

FILE=./address
if [ ! -e "$FILE" ]
then
	echo Specify first address of subnet, that you would like to give to peers
	read ADDRESS
    	if ( $ADDRESS < 1 && $ADDRESS > 255)
	then
		echo "First address out of range (1,255)"
		exit 1
    	fi
	echo $ADDRESS > ./address
else 
	ADDRESS=$(cat ./address)
fi
exit 1
wg-quick down wg0
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
