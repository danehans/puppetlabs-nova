#
# Installs and configures consoleauth service
#
# The consoleauth service is required for vncproxy auth
# for Horizon
#
class nova::consoleauth(
  $enabled           = false,
  $memcached_servers = '127.0.0.1',
  $ensure_package    = 'present',
) {

  include nova::params

  nova_config {'memcached_servers': value => $memcached_servers;}

  nova::generic_service { 'consoleauth':
    enabled        => $enabled,
    package_name   => $::nova::params::consoleauth_package_name,
    service_name   => $::nova::params::consoleauth_service_name,
    ensure_package => $ensure_package,
  }

}
