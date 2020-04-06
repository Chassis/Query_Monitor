# Query Monitor
A [Chassis](https://github.com/Chassis/Chassis) extension to install and configure your Chassis WP install to use Query Monitor to help with debugging.

## What's this plugin do

This Chassis extension installs and activates Query Monitor using Puppet and WP-CLI.

## Usage
1. Clone Chassis `git clone --recursive https://github.com/Chassis/Chassis chassis`
2. Add this extension to your extensions directory `cd chassis && git clone git@github.com:Chassis/Query-Monitor.git extensions/query_monitor`
3. Run `vagrant provision`
4. Fin!

## Integrating Query Monitor with IDEs

To integrate Query Monitor with your IDE you will need to add a filters to your code to map the remote directory in Chassis to your local directory, e.g.
```
<?php
$data = json_decode( file_get_contents( '/etc/chassis-constants' ) );

add_filter( 'qm/output/file_path_map', function ( $map ) use ( $data ) {
	$map = array_merge( $map, (array) $data->synced_folders );
	return $map;
} );
```
