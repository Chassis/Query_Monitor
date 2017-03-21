# Install the Query Monitor plugin
class querymonitor (
  $path = '/vagrant/extensions/querymonitor'
) {
  if ! ( File['/vagrant/content'] ) {
    file { '/vagrant/content':
      ensure => 'directory',
    }
  }
  if ! ( File['/vagrant/content/plugins'] ) {
    file { '/vagrant/content/plugins':
      ensure => 'directory',
    }
  }
  wp::plugin { 'query-monitor':
    ensure   => enabled,
    location => '/vagrant/wp',
    require  => Class['wp'],
  }
  file { '/vagrant/content/db.php':
    ensure  => 'link',
    target  => '/vagrant/content/plugins/query-monitor/wp-content/db.php',
    require => Wp::Plugin['query-monitor'],
  }
  exec { "/usr/bin/wp cap add 'administrator' 'view_query_monitor'":
    user    => 'www-data',
    require => [ Class['wp'], Wp::Plugin['query-monitor'] ],
    cwd     => '/vagrant/wp',
  }
}
