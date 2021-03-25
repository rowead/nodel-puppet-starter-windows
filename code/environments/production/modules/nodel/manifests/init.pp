# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include nodel
class nodel (
  String $nodel_jar = "https://github.com/museumsvictoria/nodel/releases/download/v2.1.1-release391/nodelhost-release-2.1.1-rev391.jar",
  Enum['present', 'absent'] $ensure = present,
  Boolean $manage_config = false,
  Boolean $allow_upgrades = true,
) {

  $nodel_root = "C:/nodel"

  contain nodel::install
  contain nodel::config
  # contain nodel::service

  Class['::nodel::install']
  -> Class['::nodel::config']
  # ~> Class['::nodel::service']
}
