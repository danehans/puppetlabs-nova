class nova::network::quantum (
  $fixed_range,
  $use_dhcp                = 'True',
  $public_interface        = undef,
  $quantum_connection_host = localhost,
  $network_api_class	   = 'nova.network.quantumv2.api.API',
  $quantum_url		   = 'http://127.0.0.1:9696',
  $quantum_auth_strategy   = 'keystone',
  $quantum_admin_tenant_name	= 'services',
  $quantum_admin_username	= 'quantum',
  $quantum_admin_password	= 'quantum',
  $quantum_admin_auth_url	= 'http://127.0.0.1:35357/v2.0',
  $quantum_ip_overlap           = true,
  $libvirt_vif_driver	   = 'nova.virt.libvirt.vif.LibvirtOpenVswitchDriver',
  $libvirt_use_virtio_for_bridges	= 'True',
  $host		= 'compute',

) {

  if $public_interface {
    nova_config { 'public_interface': value => $public_interface }
  }

  if $quantum_host != 'localhost' {
    nova_config { 'quantum_connection_host': value => $quantum_connection_host }
  }
  
  if $quantum_ip_overlap == 'true' {
    nova_config { 'firewall_driver': value => 'nova.virt.firewall.NoopFirewallDriver' }
  }
  else {
    nova_config { 'firewall_driver': value => 'nova.virt.libvirt.firewall.IptablesFirewallDriver' }
  }

  nova_config { 
    'network_api_class': value => $network_api_class;
    'quantum_url': value => $quantum_url;
    'quantum_auth_strategy': value => $quantum_auth_strategy;
    'quantum_admin_tenant_name': value => $quantum_admin_tenant_name;
    'quantum_admin_username': value => $quantum_admin_username;
    'quantum_admin_password': value => $quantum_admin_password;
    'quantum_admin_auth_url': value => $quantum_admin_auth_url;
}
   if $host == 'compute' {
    	 nova_config {
	'libvirt_vif_driver': value => $libvirt_vif_driver;
    'libvirt_use_virtio_for_bridges': value => $libvirt_use_virtio_for_bridges;
  }
 }

}
