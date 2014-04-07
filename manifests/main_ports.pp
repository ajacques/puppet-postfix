class postfix::main_ports (
	$require = undef,
	$notify = undef
) {
	Postfix::Server_port {
		require => $require,
		notify => $notify
	}

	postfix::server_port {'postfix_cleanup':
		service_name => 'cleanup',
		service_type => 'unix',
		max_proc => 0,
		private => false,
		command => 'cleanup',
	}

	postfix::server_port {'postfix_qmgr':
		service_name => 'qmgr',
		service_type => 'fifo',
		wakeup => 300,
		max_proc => 1,
		private => false,
		command => 'qmgr',
	}

	postfix::server_port {'postfix_tlsmgr':
		service_name => 'tlsmgr',
		service_type => 'unix',
		max_proc => 1,
		wakeup => '1000?',
		command => 'tlsmgr',
	}

	postfix::server_port {'postfix_rewrite':
		service_name => 'rewrite',
		service_type => 'unix',
		chroot => false,
		command => 'trivial-rewrite',
	}

	postfix::server_port {'postfix_bounce':
		service_name => 'bounce',
		service_type => 'unix',
		max_proc => 0,
		command => 'bounce',
	}

	postfix::server_port {'postfix_defer':
		service_name => 'defer',
		service_type => 'unix',
		max_proc => 0,
		command => 'bounce',
	}

	postfix::server_port {'postfix_trace':
		service_name => 'trace',
		service_type => 'unix',
		max_proc => 0,
		command => 'bounce',
	}

	postfix::server_port {'postfix_verify':
		service_name => 'verify',
		service_type => 'unix',
		max_proc => 1,
		command => 'verify',
	}

	postfix::server_port {'postfix_flush':
		service_name => 'trace',
		service_type => 'unix',
		max_proc => 0,
		private => false,
		wakeup => '1000?',
		command => 'flush',
	}

	postfix::server_port {'postfix_proxymap':
		service_name => 'proxymap',
		service_type => 'unix',
		chroot => false,
		command => 'proxymap',
	}

	postfix::server_port {'postfix_proxyrewrite':
		service_name => 'proxywrite',
		service_type => 'unix',
		chroot => false,
		max_proc => 1,
		command => 'proxymap',
	}

	# SMTP client used to forward mail to other hosts
	postfix::server_port {'postfix_smtp_client':
		service_name => 'smtp',
		service_type => 'unix',
		command => 'smtp',
	}

	postfix::server_port {'postfix_shoq':
		service_name => 'showq',
		service_type => 'unix',
		private => false,
		command => 'showq',
	}

	postfix::server_port {'postfix_error':
		service_name => 'error',
		service_type => 'unix',
		command => 'error',
	}

	postfix::server_port {'postfix_retry':
		service_name => 'retry',
		service_type => 'unix',
		command => 'error',
	}

	postfix::server_port {'postfix_discard':
		service_name => 'discard',
		service_type => 'unix',
		command => 'discard'
	}

	postfix::server_port {'postfix_local':
		service_name => 'local',
		service_type => 'unix',
		unpriv => false,
		chroot => false,
		command => 'local'
	}

	# TLS session ticket cache
	postfix::server_port {'postfix_scache':
		service_name => 'scache',
		service_type => 'unix',
		max_proc => 1,
		command => 'scache',
	}

	# Client throttling
	postfix::server_port {'postfix_anvil':
		service_name => 'anvil',
		service_type => 'unix',
		max_proc => 1,
		command => 'anvil',
	}

	postfix::server_port {'postfix_virtual':
		service_name => 'virtual',
		service_type => 'unix',
		unpriv => false,
		chroot => false,
		command => 'virtual'
	}
}
