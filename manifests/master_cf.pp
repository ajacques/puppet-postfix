class postfix::master_cf (
	$require = undef,
	$file_path = "${postfix::config::config_dir}/master.cf"
) {
	concat {$file_path:
		owner => 'root',
		group => 'root',
		mode => '0444',
		require => $require
	}

	concat::fragment {"master_cf_block_000_header":
		target => $file_path,
		content => template('postfix/master.cf.erb')
	}
}
