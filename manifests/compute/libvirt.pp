class nova::compute::libvirt (
  $libvirt_type = 'kvm',
  $vncserver_listen = '127.0.0.1'
) {

  include nova::params

  Service['libvirt'] -> Service['nova-compute']

  if($::nova::params::compute_package_name) {
    package { "nova-compute-${libvirt_type}":
      ensure => present,
      before => Package['nova-compute'],
      tag    => "openstack",
    }
  }

  package { 'libvirt':
    name   => $::nova::params::libvirt_package_name,
    ensure => present,
    tag    => "openstack",
  }

  service { 'libvirt' :
    name     => $::nova::params::libvirt_service_name,
    ensure   => running,
    provider => $::nova::params::special_service_provider,
    require  => Package['libvirt'],
  }

  File<| name == '/etc/libvirt/qemu.conf' |> ~> Service['libvirtd']

  nova_config { 'libvirt_type': value => $libvirt_type }
  nova_config { 'compute_driver': value => 'libvirt.LibvirtDriver' }
  nova_config { 'vncserver_listen': value => $vncserver_listen }
}
