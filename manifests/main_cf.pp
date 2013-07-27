class postfix::main_cf (
	$require = undef
) {
	concat {'/etc/postfix/main.cf':
		owner => 'root',
		group => 'root',
		mode => '0444',
		require => $require
	}

	concat::fragment {"cf_block_000_header":
		target => '/etc/postfix/main.cf',
		content => template('postfix/main.cf.erb')
	}
}
