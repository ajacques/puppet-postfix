class postfix (
	$ensure = present,
	$ssl_certificate_path = undef,
	$custom_master = undef,
	$custom_main = undef,
	$mynetworks = ''
) {
	package {'postfix':
		ensure => $ensure,
	}
	package {'postfix-mysql':
		ensure => $ensure
	}
	class {'postfix::config':
		require => Package['postfix'],
		notify => Exec['postfix-reload'],
		ensure => $ensure
	}

	class {'postfix::main_ports':
		require => Package['postfix'],
		notify => Exec['postfix-reload']
	}

	exec {'postfix-reload':
		command => '/usr/bin/env postfix reload',
		refreshonly => true,
		require => Service['postfix']
	}

	service {'postfix':
		hasstatus => true,
		hasrestart => true,
		require => Package['postfix']
	}

	if defined(Class['monit']) {
		monit::service_monitor {'monit_postfix_srv':
			service_name => 'postfix',
			pid_file => '/var/spool/postfix/pid/master.pid',
			start_path => '/etc/init.d/postfix start',
			stop_path => '/etc/init.d/postfix stop',
			max_restarts => 3,
			require => Package['postfix']
		}
	}
}
