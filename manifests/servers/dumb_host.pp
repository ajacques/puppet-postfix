class postfix::servers::dumb_host (
	$relay_host = $::postfix_relayhost
) {
	postfix::cf_property {'postfix_relayhost':
		variable => 'relayhost',
		value => $relay_host
	}

	postfix::server_port {'pickup':
		service_name => 'pickup',
		service_type => 'fifo',
		wakeup => 60,
		max_proc => 1,
		private => false,
		command => 'pickup'
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
