class postfix::servers::dumb_host (
	$relay_host = undef,
	$username = undef,
	$password = undef
) {
	postfix::cf_property {'postfix_relayhost':
		variable => 'relayhost',
		value => $relay_host
	}
	if $username != undef {
		postfix::cf_property {'postfix_smtp_sasl_auth_enable':
			variable => 'smtp_sasl_auth_enable',
			value => 'yes'
		}
		postfix::cf_property {'postfix_sasl_password_map':
			variable => 'smtp_sasl_password_maps',
			value => 'hash:${config_directory}/relay_password'
		}
		exec {'postfix_relay_password_postmap':
			refreshonly => true,
			command => "/usr/sbin/postmap ${postfix::config::config_dir}/relay_password",
			require => File["${postfix::config::config_dir}/relay_password"]
		}

		file {"${postfix::config::config_dir}/relay_password":
			owner => 'root',
			group => 'root',
			mode => '400',
			notify => Exec['postfix_relay_password_postmap'],
			content => "${relay_host} ${username}:${password}"
		}

		postfix::cf_property {'posfix_sasl_security_options':
			variable => 'smtp_sasl_security_options',
			value => ''
		}
	}

	if defined(Class['iptables']) {
		iptables::rule { 'allow-submission-out':
			chain => 'TCP_OUT',
			destination_port => ['submission'],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
	}
}
