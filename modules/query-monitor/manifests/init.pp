# Install the Query Monitor plugin
class query-monitor (
	$config,
	$path = '/vagrant/extensions/query-monitor',
	$content_location = $config[mapped_paths][content],
	$location =  $config[mapped_paths][base]
) {
	if versioncmp($config[php], '5.4') <= 0 {
		$php_package = 'php5'
	} else {
		$short_ver = regsubst($config[php], '^(\d+\.\d+)\.\d+$', '\1')
		$php_package = 'php'
	}

	if ( $location != '/vagrant' ) {
		$base_location = "${location}/chassis"
	} else {
		$base_location = $location
	}

	notice($base_location)

	if !( File["${content_location}"] ) {
		file { "${content_location}":
		  ensure => 'directory',
		}
	}
	if !( File["${content_location}/plugins"] ) {
		file { "${content_location}/plugins":
		  ensure => 'directory',
		}
	}

	wp::plugin { 'query-monitor':
		ensure   => enabled,
		location => "${base_location}/wp",
		require  => [ Class['wp'], Service["php${short_ver}-fpm"] ],
	}

	file { "${content_location}/db.php":
		ensure  => 'link',
		target  => "${content_location}/plugins/query-monitor/wp-content/db.php",
		require => Wp::Plugin['query-monitor'],
	}

	exec { "/usr/bin/wp cap add 'administrator' 'view_query_monitor'":
		user    => 'www-data',
		require => [ Class['wp'], Wp::Plugin['query-monitor'] ],
		cwd     => "${base_location}/wp",
	}
}
