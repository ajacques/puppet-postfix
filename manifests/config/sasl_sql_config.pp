define postfix::config::sasl_sql_config (
	$file_name = undef,
	$sql_engine = undef,
	$sql_hostname = undef,
	$sql_database = undef,
	$sql_username = undef,
	$sql_password = undef,
	$sql_select_query = undef,
	$mechanisms = 'CRAM-SHA1 CRAM-SHA256 DIGEST-MD5 CRAM-MD5 PLAIN',
	$require = undef,
	$notify = undef
) {
	file {"/etc/postfix/sasl/$file_name.conf":
		owner => 'root',
		group => 'root',
		mode => '0440',
		require => $require,
		notify => $notify,
		content => template('postfix/sasl_sql_config.cf.erb')
	}
}
