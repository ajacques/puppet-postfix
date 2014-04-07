class postfix::config (
	$require = undef,
	$notify = undef,
	$config_dir = '/etc/postfix'
) {
	File {
		owner => 'root',
		group => 'root'
	}

	file {$config_dir:
		ensure => directory,
		mode => '0555'
	}

	file {"${config_dir}/sasl":
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
		command => "/usr/bin/openssl gendh -out ${config_dir}/dh_512.pem 512",
		unless => "/usr/bin/test -f ${config_dir}/dh_512.pem",
		require => [
			File[$config_dir]
		]
	}

	exec {'postfix-generate-1024bit-dh-param':
		command => "/usr/bin/openssl gendh -out ${config_dir}/dh_1024.pem 1024",
		unless => "/usr/bin/test -f ${config_dir}/dh_1024.pem",
		require => [
			File[$config_dir]
		]
	}

	file {"${config_dir}/dh_512.pem":
		mode => '0400',
		require => Exec['postfix-generate-512bit-dh-param']
	}

	file {"${config_dir}/dh_1024.pem":
		mode => '0400',
		require => Exec['postfix-generate-1024bit-dh-param']
	}

	if ($postfix::custom_master) {
		concat::fragment {'postfix-custom-master':
			target => "${config_dir}/master.cf",
			source => $postfix::custom_master
		}
	}
	
	if ($postfix::custom_main) {
		concat::fragment {'postfix-custom-main':
			target => "${config_dir}/main.cf",
			source => $postfix::custom_main
		}
	}

	if ($postfix::ssl_install_certificate) {
		file {"${config_dir}/ssl-certificate.pem":
			source => $postfix::ssl_source_path
		}

		postfix::config::parameter {'postfix-ssl-key':
			variable => 'smtpd_tls_cert_file',
			content => "${config_dir}/ssl-certificate.pem"
		}
	} else {
		postfix::config::parameter {'postfix-ssl-public-key':
			variable => 'smtpd_tls_cert_file',
			content => $::postfix_tls_key_path
		}
	}
}
