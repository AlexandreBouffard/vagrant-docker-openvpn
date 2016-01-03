Vagrant.configure('2') do |config|
  # Enable vagrant-env plugin in order to load environment variables from .env file
  config.env.enable

  config.ssh.username = 'vagrant'
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder 'config', "/home/#{config.ssh.username}/config"

  config.vm.provider 'digital_ocean' do |provider, override|
    override.ssh.private_key_path = ENV['SSH_PRIVATE_KEY_PATH']
    override.vm.box = 'digital_ocean'
    override.vm.box_url = 'https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box'
    override.vm.hostname = 'openvpn-' + ENV['DO_REGION']

    provider.token = ENV['DO_TOKEN']
    provider.region = ENV['DO_REGION']
    provider.image = 'ubuntu-14-04-x64'
    provider.size = '512mb'
    provider.ssh_key_name = ENV['DO_SSH_KEY_NAME']
  end

  # Fix tty error message
  config.vm.provision 'shell', privileged: false, inline: "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"

  # Setup firewall
  config.vm.provision 'shell', path: 'scripts/setup-firewall.sh'

  # Setup swap
  config.vm.provision 'shell', path: 'scripts/setup-swap.sh'

  # Setup Docker
  config.vm.provision 'docker'
  # Force SSH reconnect to apply user group config
  config.vm.provision 'shell', inline: "ps aux | grep 'sshd:' | awk '{print $2}' | xargs kill"

  # Setup OpenVPN
  ovpn_data = 'ovpn-data'
  # Server
  config.vm.provision 'shell' do |s|
    s.privileged = false
    s.path = 'scripts/setup-openvpn-server.sh'
    s.args = [ovpn_data]
  end
  # Client configurations
  ENV['OVPN_CLIENT_NAMES'].split(',').map(&:strip).each do |c|
    ovpn_client_name = ENV['DO_REGION'] + '-' + Time.new.strftime("%Y%m%dT%H%M%S") + '-' + c
    config.vm.provision 'shell' do |s|
      s.privileged = false
      s.path = 'scripts/setup-openvpn-client.sh'
      s.args = [ovpn_data, ovpn_client_name]
    end
  end
end
