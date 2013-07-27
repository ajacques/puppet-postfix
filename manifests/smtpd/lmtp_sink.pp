define postfix::smtpd::lmtp_sink (
	$lmtp_transport = 'lmtp',
	$lmtp_host = 'localhost',
	$lmtp_port = 24,
	$domains_file = undef,
	$mailbox_file = undef
) {
	postfix::cf_block {'lmtp_settings':
		filename => 'main.cf',
		content => template('postfix/lmtp_settings.cf.erb')
	}

	postfix::config::parameter_list {'lmtp_sql_domains':
		variable => 'virtual_mailbox_domains',
		content => $domains_file
	}

	postfix::config::parameter_list {'lmtp_sql_mailbox':
		variable => 'virtual_mailbox_maps',
		content => $mailbox_file,
	}
}
