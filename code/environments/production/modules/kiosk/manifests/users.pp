# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kiosk::users
class kiosk::users {

  $kiosk_users = lookup({
    'name'  => 'kiosk::users',
    'merge' => {
      'strategy' => 'deep',
    },
  })

  each($kiosk_users) |$key, $kiosk_user| {

    user { "${key}":
      ensure   => $kiosk_user['ensure'],
      groups   => $kiosk_user['groups'],
      password => $kiosk_user['password'],
    }

    if ($kiosk_user['autologin'] == true) {
      registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName':
        ensure  => present,
        data   => "${key}",
        type    => string,
        require => User["${key}"]
      }

      registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword':
        ensure  => present,
        data   => $kiosk_user['password'],
        type    => string,
        require => User["${key}"]
      }

      registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName':
        ensure  => present,
        data   => $hostname,
        type    => string,
        require => User["${key}"]
      }

      registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
        ensure  => present,
        data   => '1',
        type    => string,
        require => User["${key}"]
      }
    }

    if ($kiosk_user['launch_nodel'] == true) {
      if (directory_exists("C:/Users/${key}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup")) {
        file { "C:/Users/${key}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/launch-nodel.bat":
          ensure  => file,
          content  => file('nodel/launch-nodel.bat'),
          require => Class['nodel']
        }
      }

    }

  }
}
