puppet-postfix
==============

This is a Puppet configuration module that can be used to install and configure Postfix.

## Dependencies ##
This module makes use of a few other Puppet modules if they are installed and enabled, but they are not required to function.
* ajacques/puppet-monit - Will create a new service monitor to ensure that the Postfix process is running. Also has a few conservative resource constraints

# Examples #
Enable port 587:

This will tell Postfix to start listening on the MSA (submission, TCP port 587) port and accept only SASL authenticated email messages.
<pre><code>
postfix::server_port {'postfix_submission':
	service_name => 'submission',
	service_type => 'inet',
	private => false,
	command => 'smtpd -o smtpd_sender_restrictions=permit_sasl_authenticated,reject -o milter_macro_daemon_name=ORIGINATING -o content_filter='
}
</code></pre>
