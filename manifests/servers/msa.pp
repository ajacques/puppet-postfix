class postfix::servers::msa {
	postfix::server_port {'postfix_submission':
		service_name => 'submission',
		service_type => 'inet',
		private => false,
		command => 'smtpd -o smtpd_sender_restrictions=permit_mynetworks,permit_sasl_authenticated,reject -o milter_macro_daemon_name=ORIGINATING -o content_filter='
	}

	postfix::server_port {'postfix_smtpd':
		service_name => 'smtp',
		service_type => 'inet',
		command => 'smtpd',
		private => false
	}

	postfix::server_port {'smtps':
		service_name => 'smtps',
		service_type => 'inet',
		command => 'smtpd -o smtpd_tls_wrappermode=yes',
		private => false
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
			table => 'filter',
			destination_port => ['587'],
			protocol => 'tcp',
			action => 'ACCEPT',
			order => 30
		}
	}
}
