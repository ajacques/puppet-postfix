define postfix::config::parameter(
	$variable = undef,
	$content = undef
) {
	postfix::cf_block {"postfix_main_cf_${variable}":
		filename => 'main.cf',
		content => "${variable} = ${content}\n"
	}
}
