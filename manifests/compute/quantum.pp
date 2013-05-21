class nova::compute::quantum (
  $libvirt_vif_driver = 'nova.virt.libvirt.vif.LibvirtOpenVswitchDriver'
){

  nova_config {
    'DEFAULT/libvirt_vif_driver':             value => $libvirt_vif_driver;
    'DEFAULT/libvirt_use_virtio_for_bridges': value => 'True';
  }

  if $libvirt_vif_driver == 'nova.virt.libvirt.vif.LibvirtOpenVswitchDriver' {
    Package['libvirt'] ->
    file_line { 'quemu_hack':
      line        => 'cgroup_device_acl = ["/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom", "/dev/ptmx", "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet", "/dev/net/tun",]',
      path        => '/etc/libvirt/qemu.conf',
      ensure      => present,
    } ~> Service['libvirt']
  }

}
