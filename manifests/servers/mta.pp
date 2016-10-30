class postfix::servers::mta {
	include postfix

	postfix::cf_block {'smtp_client':
		filename => 'main.cf',
		content => template('postfix/main_smtp_client.cf.erb')
	}

	postfix::config::parameter_list {'smtpd_permit_mynetworks':
		variable => 'smtpd_recipient_restrictions',
		order => '001',
		content => 'permit_mynetworks'
	}

	postfix::config::parameter_list {'smtpd_permit_unauthed_pipeline':
		variable => 'smtpd_recipient_restrictions',
		order => '010',
		content => 'reject_unauth_pipelining'
	}

	postfix::config::parameter_list {'smtpd_reject_unauthed_dest':
		variable => 'smtpd_recipient_restrictions',
		order => '011',
		content => 'reject_unauth_destination'
	}

	postfix::config::parameter_list {'smtpd_reject_non_fqdn_recip':
		variable => 'smtpd_recipient_restrictions',
		order => '012',
		content => 'reject_non_fqdn_recipient'
	}

	postfix::config::parameter_list {'smtpd_permit_whitelist':
        variable => 'smtpd_recipient_restrictions',
        order => '013',
        content => 'check_client_access hash:/etc/postfix/client_whitelist'
    }

	postfix::config::parameter_list {'smtpd_permit':
		variable => 'smtpd_recipient_restrictions',
		order => '999',
		content => 'permit'
	}

	if defined(Class['iptables']) {
		iptables::rule { 'allow-smtp-in':
			chain => 'NEWCONNS',
			table => 'filter',
			destination_port => ['25'],
			protocol => 'tcp',
			action => 'ACCEPT',
		}
		iptables::rule { 'allow-smtp-out':
			chain => 'TCP_OUT',
			table => 'filter',
			destination_port => ['25'],
			protocol => 'tcp',
			action => 'ACCEPT',
			raw => '-m owner --uid-owner postfix'
		}
	}
}
