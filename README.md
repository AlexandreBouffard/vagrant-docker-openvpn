# Vagrant + Docker Engine + OpenVPN

Fully automated OpenVPN server deployment using Vagrant + Docker Engine.

Deployment on DigitalOcean offering a great service and hourly billing.

## Getting Started

### Initial Steps

- Have or create a [DigitalOcean](https://www.digitalocean.com/?refcode=b07015875086) account ([referral link to earn $10 credit](https://www.digitalocean.com/?refcode=b07015875086))
- Have or generate a SSH key pair (usually at `~/.ssh/id_rsa`)
- Copy `example.env` to `.env`
- Configure `.env` environment variables:
    - `DO_TOKEN`: DigitalOcean API token (generated using DigitalOcean Control Panel)
    - `DO_REGION`: DigitalOcean region where the OpenVPN server instance will be deployed
    - `DO_SSH_KEY_NAME`: Name of SSH key in DigitalOcean account (will be uploaded to account if absent)
    - `OVPN_CLIENT_NAMES`: Comma-separated list of OpenVPN client configuration names (each client configuration needs to be uniquely identified)
    - `SSH_PRIVATE_KEY_PATH`: Path to SSH key pair (only public key will be used)
- Install [Vagrant](https://www.vagrantup.com/)
- Execute the following command to install required Vagrant plugins:

        vagrant plugin install vagrant-digitalocean vagrant-env vagrant-rsync-back

### Automated Deployment

Execute the following command to deploy an OpenVPN server instance and generate client configurations:

    vagrant up --provider digital_ocean --no-provision && vagrant provision

Note: because of a vagrant-digitalocean provider [issue](https://github.com/smdahlen/vagrant-digitalocean/issues/174), providing and provisioning the instance need to be done in separate steps.

### Retrieve Client Configurations

Execute the following command to retrieve client configurations:

    vagrant rsync-back

Client configurations should now be available in `config` folder.

### Tear Down

Execute the following command to tear down the OpenVPN server instance:

    vagrant destroy

Client configurations in `config` folder are now useless and can be deleted.

## Caveats

### Security

Beware of the following trade-offs to enable fully automated setup:

- CA key is generated without passphrase
- Server is identified by its IP address and not fully-qualified domain name

### Operating System Support

- Tested under OS X
- Should work out of the box under Linux
- Requires additional initial steps under Windows (e.g. OpenSSH, Rsync)


## Acknowledgements

- OpenVPN server Docker image: [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn)
