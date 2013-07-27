class postfix {
	package {'postfix':
		ensure => installed,
	}
	package {'postfix-mysql':
		ensure => installed
	}
	class {'postfix::config':
		require => Package['postfix'],
		notify => Service['postfix']
	}

	class {'postfix::main_ports':
		require => Package['postfix'],
		notify => Service['postfix']
	}

	service {'postfix':
		hasstatus => true,
		hasrestart => true,
		require => Package['postfix']
	}

	if defined(Class['monit']) {
		monit::service_monitor {'monit_postfix_srv':
			service_name => 'postfix',
			pid_file => 'postfix.pid',
			start_path => '/etc/init.d/postfix start',
			stop_path => '/etc/init.d/postfix stop',
			max_restarts => 3,
			require => Package['postfix']
		}
	}
}
