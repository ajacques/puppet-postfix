class postfix::servers::mta {
	include postfix

	postfix::cf_block {'smtp_client':
		filename => 'main.cf',
		content => template('postfix/main_smtp_client.cf.erb')
	}

	postfix::server_port {'postfix_smtp':
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

	postfix::parameter_list {'smtpd_permit_mynetworks':
		variable => 'smtpd_recipient_restrictions',
		order => '001',
		content => 'permit_mynetworks'
	}

	postfix::parameter_list {'smtpd_permit_unauthed_pipeline':
		variable => 'smtpd_recipient_restrictions',
		order => '010',
		content => 'reject_unauth_pipelining'
	}

	postfix::parameter_list {'smtpd_reject_unauthed_dest':
		variable => 'smtpd_recipient_restrictions',
		order => '011',
		content => 'reject_unauth_destination'
	}

	postfix::parameter_list {'smtpd_reject_non_fqdn_recip':
		variable => 'smtpd_recipient_restrictions',
		order => '012',
		content => 'reject_non_fqdn_recipient'
	}

	postfix::parameter_list {'smtpd_permit':
		variable => 'smtpd_recipient_restrictions',
		order => '999',
		content => 'permit'
	}

	if defined(Class['iptables']) {
		iptables::rule { 'allow-submission-in':
			chain => 'NEWCONNS',
			destination_port => ['smtp', 'smtps', 'submission'],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
	}
}
