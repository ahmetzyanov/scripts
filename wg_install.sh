#!/bin/sh
echo Enter port for wireguard [ 51820 ]:
read PORT
if [ $PORT=="" ]
then
 	PORT='51820'
fi

echo 'Enter wg interface number in "X.X.X.X" format (script supports only /24 netmask) [ 10.255.255.1 ]:'
read ADDRESS
if [ $ADDRESS=="" ]
then
   	ADDRESS='10.255.255.1'
fi

echo 'Enter your public interface [ ens3 ]:'
read INT_NAME
if [ $INT_NAME=="" ]
then
        INT_NAME='ens3'
fi


echo updating apt cache
apt-get update 
apt-get upgrade -y
apt-get install wireguard
echo allowing ip packets forwarding
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sysctl -p


echo 'generating private & public keys'
wg genkey | sudo tee /etc/wireguard/private.key
chmod go= /etc/wireguard/private.key
cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key

SERV_PRIV_KEY=$(cat /etc/wireguard/private.key)
SERV_PUB_KEY=$(cat /etc/wireguard/pulic.key)

echo 'generating /etc/wireguard/wg0.conf'
cat >> /etc/wireguard/wg0.conf << EOF
[Interface]
Address = $SUBNET/24
SaveConfig = true
PostUp = iptables -t nat -A POSTROUTING -o $INT_NAME -j MASQUERADE;
PostDown = iptables -t nat -D POSTROUTING -o $INT_NAME -j MASQUERADE;
ListenPort = $PORT
PrivateKey = $SERV_PRIV_KEY
EOF

echo enabling wireguard
systemctl enable wg-quick@wg0.service

echo $(systemctl status wg-quick@wg0.service)
