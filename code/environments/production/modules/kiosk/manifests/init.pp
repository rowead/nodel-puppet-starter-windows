# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kiosk
class kiosk(
  String $kiosk_root = 'C:/kiosk',
  String $deployer_git_auth = ''
) {

  if ($kiosk::deployer_git_auth) {
    $_deployer_git_auth = $kiosk::deployer_git_auth
  }

  file { "$kiosk_root":
    ensure => directory
  }

  file { "$kiosk_root/locks":
    ensure => directory
  }

  file { "$kiosk_root/scripts":
    ensure => directory
  }

  file { "$kiosk_root/scripts/puppet-run.ps1":
    ensure => present,
    content => file('kiosk/puppet-run.ps1'),
    require => File["$kiosk_root/scripts"]
  }

  if ($virtual == 'virtualbox') {
    $puppet_cron = absent
  } else {
    $puppet_cron = present
  }

  scheduled_task { "puppet run":
    ensure => $puppet_cron,
    command => "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
    arguments => "-File $kiosk_root/scripts/puppet-run.ps1",
    working_dir => 'C:/ProgramData/PuppetLabs',
    trigger => {
      schedule         => daily,
      start_time       => '8:00',
      minutes_interval => 5
    }
  }

  vcsrepo { "$kiosk_root/scripts/deployer":
    ensure   => latest,
    provider => git,
    source   => "https://github.com/rowead/deployer.git",
    revision => 'master'
  }

  file { "$kiosk_root/scripts/npm-install.ps1":
    ensure  => present,
    content => file('kiosk/npm-install.ps1'),
    require => [
      Package['nodejs']
    ]
  }

  exec { "deployer updated":
    path        => $::path,
    cwd         => "$kiosk_root/scripts/deployer",
    command     => "$kiosk_root/scripts/npm-install.ps1",
    provider    => powershell,
    refreshonly => true,
    subscribe   => Vcsrepo["$kiosk_root/scripts/deployer"],
    require     => [
      File["$kiosk_root/scripts/npm-install.ps1"]
    ]
  }

  package { 'nodejs':
    provider => 'chocolatey',
    ensure   => '15.11.0',
  }

  package { 'vscode':
    provider => 'chocolatey',
    ensure   => 'latest',
  }
}
