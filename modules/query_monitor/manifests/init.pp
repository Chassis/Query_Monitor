# Install the Query Monitor plugin
class query_monitor (
	$config,
	$path = '/vagrant/extensions/query_monitor',
	$content_location = $config[mapped_paths][content],
	$location =  $config[mapped_paths][base]
) {
	# Get the PHP variables we need.
	if versioncmp($config[php], '5.4') <= 0 {
		$php_package = 'php5'
	} else {
		$short_ver = regsubst($config[php], '^(\d+\.\d+)\.\d+$', '\1')
		$php_package = 'php'
	}

	# Setup the base paths for custom Chassis paths.
	if ( $location != '/vagrant' ) {
		$base_location = "${location}/chassis"
	} else {
		$base_location = $location
	}

	if !( File[$content_location] ) {
		file { $content_location:
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
		require  => Chassis::Wp[ $config['hosts'][0] ]
	}

	file { "${content_location}/db.php":
		ensure  => 'link',
		target  => "${content_location}/plugins/query-monitor/wp-content/db.php",
		require => Chassis::Wp[ $config['hosts'][0] ],
	}
}
