define nova::manage::project ( $owner ) {

  File['/etc/nova/nova.conf'] -> Nova_project[$name]
  Exec<| title == 'nova-db-sync' |> -> Nova_project[$name]

  nova_project { $name:
    ensure   => present,
    owner    => $owner,
    require  => Nova::Manage::Admin[$owner],
  }
}
