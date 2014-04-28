node raspberrypi {
  package { "vim":
    ensure => "latest"
  }
  network_config { 'lo':
    ensure => 'present',
    family => 'inet',
    method => 'loopback',
    onboot => 'true',
  }
}
