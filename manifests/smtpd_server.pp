class postfix::smtpd_server {
	concat::fragment {'main-cf-smtpd-server':
		target => "${postfix::config::config_dir}/main.cf",
		content => template('postfix/main_smtpd_server.cf.erb')
	}
}
