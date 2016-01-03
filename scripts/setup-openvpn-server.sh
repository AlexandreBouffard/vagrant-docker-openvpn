OVPN_DATA=$1

# Create Docker volume
docker create --name $OVPN_DATA -v /etc/openvpn busybox

# Generate server configuration
PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$PUBLIC_IPV4
docker run --volumes-from $OVPN_DATA --rm -e "EASYRSA_BATCH=1" kylemanna/openvpn ovpn_initpki nopass

# Start server
sudo sh -c "cat > /etc/init/docker-openvpn.conf" <<EOF
description "Docker container for OpenVPN server"
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  exec docker run --volumes-from $OVPN_DATA --rm -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
end script
EOF
sudo start docker-openvpn
