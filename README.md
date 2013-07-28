puppet-postfix
==============

This is a Puppet configuration module to be used to install and configure Postfix.

# Examples #
Enable port 587:
<pre><code>
postfix::server_port {'postfix_submission':
	service_name => 'submission',
	service_type => 'inet',
	private => false,
	command => 'smtpd -o smtpd_sender_restrictions=permit_sasl_authenticated,reject -o milter_macro_daemon_name=ORIGINATING -o content_filter='
}
</code></pre>
