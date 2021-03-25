# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodel::install
class nodel::install {

  file { "${nodel::nodel_root}":
    ensure => directory,

  }
  file { "${nodel::nodel_root}/nodes":
    ensure  => directory,
    require => File["${nodel::nodel_root}"]
  }

  file { "${nodel::nodel_root}/recipes":
    ensure  => directory,
    require => File["${nodel::nodel_root}"]
  }

  file { "${nodel::nodel_root}/version.txt":
    ensure  => present,
    require => File["${nodel::nodel_root}"],
    content => $nodel::nodel_jar,
    notify  => Exec['download nodel.jar']
  }

  file { "${nodel::nodel_root}/launch-nodel.bat":
    ensure => present,
    content => file('nodel/launch-nodel.bat')
  }

  package { 'javaruntime':
    provider => 'chocolatey',
    ensure   => '8.0.231',
  }

  exec { 'download nodel.jar':
    command     => "Invoke-WebRequest '${nodel::nodel_jar}' -UseBasicParsing -OutFile '${nodel::nodel_root}/nodel.jar'",
    provider    => powershell,
    onlyif      => "test '${nodel::allow_upgrades}' = 'true'",
    refreshonly => true,
    path        => $path,
    require     => File["${nodel::nodel_root}"]
  }

  reboot { 'after':
    subscribe => Exec['download nodel.jar'],
    apply     => finished
  }

}
