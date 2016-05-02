class querymonitor (
  $path = "/vagrant/extensions/themereview"
) {
  file { "/vagrant/content":
    ensure => "directory",
  }
  file { "/vagrant/content/plugins":
    ensure => "directory",
  }
  wp::plugin { 'query-monitor':
    ensure   => enabled,
    location => '/vagrant/wp',
    require  => Class['wp'],
  }

}
