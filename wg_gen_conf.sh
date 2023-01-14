#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a name"
  exit 1
fi

NAME=$1

ADDR_FILE=./address
SUBN_FILE=./subnet
if [ ! -e "$ADDR_FILE" ]
then
	echo Enter first address of subnet, that you would like to give to peers [10]:
	read ADDRESS
	if [ $ADDRESS=="" ]
	then 
		ADDRESS=10
    	elif [ $ADDRESS < 1 && $ADDRESS > 255]
	then
		echo "First address out of range (1,255)"
		exit 1
    	fi
	echo $ADDRESS > $ADDR_FILE
else 
	ADDRESS=$(cat $ADDR_FILE)
fi
if [ ! -e "$SUBN_FILE" ]
then
	echo 'Enter subnet in format "X.X.X." . Only 24 masks permitted. [10.255.255.]:'
	read SUBNET
	if [ $SUBNET=="" ]
	then
		SUBNET='10.255.255.'
	fi
	echo $SUBNET > $SUBN_FILE
fi

exit 1
wg-quick down wg0
wg genkey | tee $NAME.key | wg pubkey > $NAME.pub

PRIVATE=$(cat $NAME.key)
PUBLIC=$(cat $NAME.pub)

cat > $NAME.conf << EOF
[Interface]
PrivateKey = $PRIVATE
Address = $SUBNET.$ADDRESS/24
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
