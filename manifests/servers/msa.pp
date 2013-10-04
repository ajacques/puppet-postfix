class postfix::servers::msa {
	postfix::server_port {'postfix_submission':
		service_name => 'submission',
		service_type => 'inet',
		private => false,
		chroot => false, # Needs access to MySQL sockets. Can we use TCP?
		command => 'smtpd -o smtpd_sender_restrictions=permit_mynetworks,permit_sasl_authenticated,reject -o milter_macro_daemon_name=ORIGINATING -o content_filter='
	}

	class {'postfix::smtpd_server':
		
	}

	postfix::cf_block {'postfix_sasl':
		filename => 'main.cf',
		content => template('postfix/sasl_config_block.cf.erb')
	}

	if defined(Class['iptables']) {
		iptables::rule { 'allow-submission-in':
			chain => 'NEWCONNS',
			destination_port => ['587'],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
	}
}