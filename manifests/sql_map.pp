define postfix::sql_map (
	$username = undef,
	$password = undef,
	$hosts = undef,
	$dbname = undef,
	$query = undef,
	$require = undef,
	$notify = undef
) {
	file {"/etc/postfix/${name}.cf":
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0440',
		content => template('postfix/sql_map.cf.erb'),
		require => $require,
		notify => $notify
	}
}
