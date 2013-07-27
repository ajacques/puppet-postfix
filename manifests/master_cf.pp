class postfix::master_cf (
	$require = undef
) {
	concat {'/etc/postfix/master.cf':
		owner => 'root',
		group => 'root',
		mode => '0444',
		require => $require
	}

	concat::fragment {"master_cf_block_000_header":
		target => '/etc/postfix/master.cf',
		content => template('postfix/master.cf.erb')
	}
}
