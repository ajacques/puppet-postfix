define postfix::cf_block (
	$filename = '',
	$content = ''
) {
	concat::fragment {"cf_block_fragment_$name":
		target => "/etc/postfix/$filename",
		content => $content
	}
}
