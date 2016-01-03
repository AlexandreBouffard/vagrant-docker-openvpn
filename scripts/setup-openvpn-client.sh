OVPN_DATA=$1
CLIENT_NAME=$2

# Generate client configuration
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn easyrsa build-client-full $CLIENT_NAME nopass

# Export client configuration
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $CLIENT_NAME > config/$CLIENT_NAME.ovpn
