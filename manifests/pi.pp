node raspberrypi {

  file {'/home/pi/.ssh':
    ensure            =>  directory,
    owner             =>  'pi',
    group             =>  'pi',
    mode              =>  '0700',
  }

  ssh_authorized_key { 'pawel@pawel-pc':
    ensure => 'present',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCqLEgQHDcG+e3c7CFC4hEpx8aorvSTJww132W7r8+ps5zAGfzh+zAY85jXMK9YC4G7gdA9EVX7ODzw/8W+63PbIHtquBVVyH+fEKkv70KC71ZRp52P0Ve1sMgihX7ErlVT3vw55Cd4x71NXXDTB+uAlynJDa4YYhWtkZkZ9Su/wVe+F4q3lmGmptuytCs4BzSWPiu+rUaWo18IXpPrx2EypkXiRrKTSem2BH+Zllw+EtXq7VUHKXzaPLHEshtAMTfxunPIs1QSwpOvc61Ntsw2154N+tbpDAyr0hUMeCsR2PdMEQTk+iU53JFbgl6mhGf1AMwsDpb5dxeCC3vkx4A7',
    type => 'rsa',
    user => 'pi',
    require => File['/home/pi/.ssh'],
  }

  ssh_authorized_key { 'pawel@macbook':
    ensure => 'present',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCitjt7Lxcs4DHzRA/HLP+1RpgTI92v9nw/eitKQeeSRj82E7kYl7zRcgmzsTEDkT3S8YEkf3/R5xBUmFlHvbUJU0PuQ2Dd8KQus3ck81hNMWOYpgRDLOQTA86kOMOSNdHEz3qmJQXYK1qPAk4z1EDUcyQUdOhGwJyNOToPrUShVY7csa+E+eZCk3KV5OJGBNTkN6dNrqqKZyGAf3MIfmAOm8Fghg7setHArwWeobXzdAimv9JiCGGUVcOiMDhC4PwMjS9opurCjmD/ea6gxIAD5o9aU2tbUu/4hHZxlKDR06jCLD7ZLNELyePxt+q+EJmr0dABBEcHhW0ERPxTruKl',
    type => 'rsa',
    user => 'pi',
    require => File['/home/pi/.ssh'],
  }

  class { 'network::interfaces':
    interfaces => {
      'eth0' => {
        'method' => 'static',
        'address' => '192.168.0.101',
        'netmask' => '255.255.255.0',
        'gateway' => '192.168.0.1',
      }
    },
    auto => ['eth0'],
  }

  package { 'vim':
    ensure => 'latest'
  }

  package { 'minidlna':
    ensure => 'latest'
  }

  service { 'minidlna':
    ensure => 'running',
    require => Package['minidlna'], 
    enable  => true, 
  }

  exec { 'add_minidlna_media_path':
    command => 'echo media_dir=/var/samba >> /etc/minidlna.conf',
    path    => '/usr/local/bin/:/bin/',
    require => Package['minidlna'],
    unless => 'grep media_dir=/var/samba /etc/minidlna.conf',
  }

  file {'/var/samba':
    ensure            =>  directory,
    mode              =>  '0777',
  }

  class { '::samba::server':
    workgroup            => 'HOME',
    server_string        => 'Raspberry Pi',
    netbios_name         => 'Raspberry',
    local_master         => 'yes',
    map_to_guest         => 'bad user',
    preferred_master     => 'yes',
    shares => {
      'homes' => [
        'comment = Home Directories',
        'browseable = no',
        'writable = yes',
      ],
      'public' => [
        'comment = Public share',
        'path = /var/samba',
        'browseable = yes',
        'writable = yes',
        'guest ok = yes',
        'available = yes',
      ],
    },
  }
}
