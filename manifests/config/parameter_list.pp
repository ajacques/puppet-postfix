define postfix::config::parameter_list (
	$variable = undef,
	$content = undef,
	$order = '001'
) {
	if !defined(Postfix::Cf_block["cf_block_${variable}_000_header"]) {
		postfix::cf_block {"cf_block_${variable}_000_header":
			filename => 'main.cf',
			content => "${variable} = \n"
		}
	}

	postfix::cf_block {"cf_block_${variable}_${order}_${name}":
		filename => 'main.cf',
		content => "	$content,\n"
	}
}
