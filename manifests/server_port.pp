define postfix::server_port (
	$service_name = undef,
	$service_type = 'inet',
	$private = true,
	$unpriv = true,
	$chroot = true,
	$wakeup = undef,
	$max_proc = undef,
	$command = undef
) {
	concat::fragment {"master_cf_block_001_${name}_01":
		target => "${postfix::config::config_dir}/master.cf",
		content => template('postfix/master_block.cf.erb'),
		notify => Exec['postfix-reload']
	}
	concat::fragment {"master_cf_block_001_${name}_99":
		target => "${postfix::config::config_dir}/master.cf",
		content => "\n",
	}
}
