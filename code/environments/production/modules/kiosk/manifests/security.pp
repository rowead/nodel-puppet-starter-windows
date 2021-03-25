# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kiosk::security
class kiosk::security {

  local_security_policy { 'Create symbolic links':
    ensure         => 'present',
    policy_setting => 'SeCreateSymbolicLinkPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => 'Administrators,Guests',
  }

  /*
   * Delay windows updates for as long as possible
   */
  $win_update_key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate'
  registry_key {"$win_update_key":
    ensure => present
  }

  registry_value {"$win_update_key\\BranchReadinessLevel":
    ensure  => present,
    data   => 16,
    type    => dword
  }

  registry_value {"$win_update_key\\DeferFeatureUpdates":
    ensure  => present,
    data   => 1,
    type    => dword
  }

  registry_value {"$win_update_key\\DeferFeatureUpdatesPeriodInDays":
    ensure  => present,
    data   => 365,
    type    => dword
  }

  registry_value {"$win_update_key\\DeferQualityUpdates":
    ensure  => present,
    data   => 1,
    type    => dword
  }

  registry_value {"$win_update_key\\DeferQualityUpdatesPeriodInDays":
    ensure  => present,
    data   => 35,
    type    => dword
  }

  registry_value {"$win_update_key\\ActiveHoursEnd":
    ensure  => present,
    data   => 0,
    type    => dword
  }

  registry_value {"$win_update_key\\ActiveHoursStart":
    ensure  => present,
    data   => 9,
    type    => dword
  }

  registry_value {"$win_update_key\\SetActiveHours":
    ensure  => present,
    data   => 1,
    type    => dword
  }

  /*
   * Manage Auto update times.
   * Only allow updates and reboots between 8am and 9am...
   * https://docs.microsoft.com/en-us/windows/deployment/update/waas-restart#registry-keys-used-to-manage-restart
   */
  registry_key {"$win_update_key\\AU":
    ensure => present
  }
  
  registry_value {"$win_update_key\\AU\\AlwaysAutoRebootAtScheduledTime":
    ensure  => present,
    data   => 1,
    type    => dword
  }

  registry_value {"$win_update_key\\AU\\AlwaysAutoRebootAtScheduledTimeMinutes":
    ensure  => present,
    data   => 15,
    type    => dword
  }

  registry_value {"$win_update_key\\AU\\AUOptions":
    ensure  => present,
    data   => 4, # Automatically download and schedule installation of updates
    type    => dword
  }

  registry_value {"$win_update_key\\AU\\NoAutoRebootWithLoggedOnUsers":
    ensure  => present,
    data   => 0, # disable do not reboot if users are logged on
    type    => dword
  }

  registry_value {"$win_update_key\\AU\\ScheduledInstallTime":
    ensure  => present,
    data   => 8,
    type    => dword
  }
}
