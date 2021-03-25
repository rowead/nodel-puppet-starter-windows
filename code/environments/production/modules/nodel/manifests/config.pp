# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodel::config
class nodel::config {

  file { "${nodel::nodel_root}/nodes/${fqdn}":
    ensure => directory,
    require => File["${nodel::nodel_root}/nodes"]
  }

  file { "${nodel::nodel_root}/recipes/WAM_Computer":
    ensure  => directory,
    require => File["${nodel::nodel_root}/recipes"]
  }

  file { "${nodel::nodel_root}/recipes/WAM_Computer/script.py":
    ensure  => present,
    content => file('nodel/config/windows/app-launcher/script.py'),
    require => File["${nodel::nodel_root}/recipes/WAM_Computer"]
  }

  if ( $nodel::manage_config == true ) {
    file { "${nodel::nodel_root}/nodes/${fqdn}/script.py":
      ensure  => present,
      content => template('nodel/config/windows/app-launcher/script.py'),
      require => File["${nodel::nodel_root}/nodes/${fqdn}"]
    }
  } else {
    exec { 'copy nodel computer node':
      command => "cp ${nodel::nodel_root}/recipes/WAM_Computer/script.py ${nodel::nodel_root}/nodes/${fqdn}/",
      creates => "${nodel::nodel_root}/nodes/${fqdn}/script.py",
      provider => 'powershell',
      path    => $path,
      require => [
        File["${nodel::nodel_root}/nodes/${fqdn}"],
        File["${nodel::nodel_root}/recipes/WAM_Computer/script.py"]
      ]
    }
  }
}
