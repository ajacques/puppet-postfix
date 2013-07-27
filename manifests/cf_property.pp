define postfix::cf_property (
	$variable = undef,
	$value = undef
) {
	postfix::cf_block {"cf_block_${variable}":
		filename => 'main.cf',
		content => "${variable} = ${value}\n"
	}
}