# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodel::service
class nodel::service {

  file { '/lib/systemd/system/nodel.service':
    ensure => present,
    content => template('nodel/service/systemd.erb'),
  }~>
  exec { 'nodel-systemd-reload':
    path => $path,
    command => 'systemctl daemon-reload',
    refreshonly => true
  }

  service {'nodel':
    ensure => running,
    enable => true,
    provider => systemd,
    require => File['/lib/systemd/system/nodel.service']
  }
}
