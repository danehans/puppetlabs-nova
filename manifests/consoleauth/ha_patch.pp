#
# This is a temporary manifest that patches
# nova consoleauth to store session toekns in memcached and support multiple IPs for high-availability:
#   https://bugs.launchpad.net/nova/+bug/989337
#
# This is only intended as a temporary fix and needs to be removed
# once the issue is resolved with upstream.  ETA Folsom-2
#
class nova::consoleauth::ha_patch() {

  # this only works on Ubuntu

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['nova-consoleauth'],
    notify  => Service['nova-consoleauth'],
  }

  file { '/usr/lib/python2.7/dist-packages/nova/consoleauth/manager.py':
    source => 'puppet:///modules/nova/consoleauth-manager.py',
  }
}
