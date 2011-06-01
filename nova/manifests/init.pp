class nova(
  # this is how to query all resources from our clutser
  $nova_cluster_id='localcluster',
  $sql_connection = false,
  $network_manager='nova.network.manager.FlatManager',
  $image_service,
  # is flat_network_bridge valid if network_manager is not FlatManager?
  $flat_network_bridge,
  $glance_host,
  $glance_port, # default is 9292
  $allow_admin_api,
  $rabbit_host,
  $rabbit_password,
  $rabbit_port,
  $rabbit_userid,
  $rabbit_virtual_host,
  # Following may need to be broken out to different nova services
  $service_down_time,
  $quota_instances,
  $quota_cores,
  $quota_volumes,
  $quota_gigabytes,
  $quota_floating_ips,
  $quota_metadata_items,
  $quota_max_injected_files,
  $quota_max_injected_file_content_bytes,
  $quota_max_injected_file_path_bytes,
  $logdir = '/var/log/nova',
  $state_path = '/var/lib/nova',
  $lock_path = '/var/lock/nova',
  $verbose = false,
  $nodaemon = false
) {

  # TODO - why is this required?
  package { "python-greenlet": ensure => present }

  class { 'nova::utilities': }
  package { ["python-nova", "nova-common", "nova-doc"]:
    ensure => present,
    require => Package["python-greenlet"]
  }

  file { $logdir:
    ensure => directory,
    mode => '751',
    owner => 'nova',
    group => 'root',
    require => Package['nova-common'],
  }

  # query out the config for our db connection
  if $sql_connection {
    nova_config { 'sql_connection': value => $sql_connection }
  } else{
    Nova_config<<| tag == $cluster_id and value == 'sql_connection' |>>
  }

  nova_config {
    'verbose': value => $verbose;
    'nodaemon': value => $nodaemon;
    'logdir': value => $logdir;
    'network_manager': value => $network_manager;
    'image_service': value => $image_service;
    # is flat_network_bridge valid if network_manager is not FlatManager?
    'flat_network_bridge': value => $flat_network_bridge;
    'glance_host': value => $glance_host;
    'glance_port': value => $glance_port; # default is 9292
    'allow_admin_api': value => $allow_admin_api;
    'rabbit_host': value => $rabbit_host;
    'rabbit_password': value => $rabbit_password;
    'rabbit_port': value => $rabbit_port;
    'rabbit_userid': value => $rabbit_userid;
    'rabbit_virtual_host': value => $rabbit_virtual_host;
    # Following may need to be broken out to different nova services
    'state_path': value => $state_path;
    'lock_path': value => $lock_path;
    'service_down_time': value => $service_down_time;
    'quota_instances': value => $quota_instances; 
    'quota_cores': value => $quota_cores;
    'quota_volumes': value => $quota_volumes;
    'quota_gigabytes': value => $quota_gigabytes;
    'quota_floating_ips': value => $quota_floating_ips;
    'quota_metadata_items': value => $quota_metadata_items;
    'quota_max_injected_files': value => $quota_max_injected_files;
    'quota_max_injected_file_content_bytes': value => $quota_max_injected_file_content_bytes;
    'quota_max_injected_file_path_bytes': value => $quota_max_injected_file_path_bytes
  }

  Nova_config<| |> { require +> Package["nova-common"] }
}
