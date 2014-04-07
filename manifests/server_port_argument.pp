define postfix::server_port_argument (
	$service_name = undef,
	$argument = undef,
	$value = undef
) {
	concat::fragment {"master_cf_block_001_${service_name}_02":
		target => '/etc/postfix/master.cf',
		content => " -o ${argument}=${value}",
		notify => Exec['postfix-reload']
	}
}
