include "console.iol"
include "string_utils.iol"
include "xml_utils.iol"

interface BlogInterface {
RequestResponse: default(undefined)(undefined)
}

outputPort Blog {
Interfaces: BlogInterface
}

init
{
	blogs[0].location = "socket://fmontesi.blogspot.com:80/feeds/posts/";
	blogs[0].protocol = "http"
}

define getEntryText
{
	if( entry.content.("@Attributes").type == "html" ) {
		article.text = entry.content
	} else {
		article.text = "Unsupported content type."
	}
}

main
{
	for( Blog -> blogs[ blogIdx ]; blogIdx = 0, blogIdx < #blogs, blogIdx++ ) {
		default@Blog()( atom );
		entry -> atom.entry[ entryIdx ];
		article -> news.article[ entryIdx ];
		for( entryIdx = 0, entryIdx < #atom.entry, entryIdx++ ) {
			article.title = entry.title;
			article.author = entry.author.name;
			article.date = entry.updated;
	
			getEntryText
		};

		valueToPrettyString@StringUtils( news )( s );
		println@Console( s )()
	}
}

