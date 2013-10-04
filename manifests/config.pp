class postfix::config (
	$require = undef,
	$notify = undef
) {
	File {
		owner => 'root',
		group => 'root'
	}

	file {'/etc/postfix':
		ensure => directory,
		mode => '0555'
	}

	file {'/etc/postfix/sasl':
		ensure => directory,
		mode => '0550'
	}

	class {'postfix::main_cf':
		require => $require,
		notify => $notify
	}
	class {'postfix::master_cf':
		require => $require,
		notify => $notify
	}

	# Generates the Diffie-Hellman parameter files
	# See http://www.postfix.org/TLS_README.html#server_tls for more information
	exec {'postfix-generate-512bit-dh-param':
		command => '/usr/bin/openssl gendh -out /etc/postfix/dh_512.pem',
		unless => '/usr/bin/test -f /etc/postfix/dh_512.pem',
		require => [
			File['/etc/postfix']
		]
	}

	exec {'postfix-generate-1024bit-dh-param':
		command => '/usr/bin/openssl gendh -out /etc/postfix/dh_1024.pem',
		unless => '/usr/bin/test -f /etc/postfix/dh_512.pem',
		require => [
			File['/etc/postfix']
		]
	}

	file {'/etc/postfix/dh_512.pem':
		mode => '0400',
		require => Exec['postfix-generate-512bit-dh-param']
	}

	file {'/etc/postfix/dh_1024.pem':
		mode => '0400',
		require => Exec['postfix-generate-1024bit-dh-param']
	}

	postfix::config::parameter {'postfix-ssl-private-key':
		variable => 'smtpd_tls_key_file',
		content => $::postfix_tls_key_path
	}

	postfix::config::parameter {'postfix-ssl-public-key':
		variable => 'smtpd_tls_cert_file',
		content => $::postfix_tls_cert_path
	}
}
