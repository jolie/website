include "frontend.iol"
include "file.iol"
include "string_utils.iol"
include "console.iol"
include "blog_reader/blog_reader.iol"

execution { concurrent }

inputPort FrontendInput {
Location: "local"
Interfaces: FrontendInterface
}

outputPort BlogReader {
Interfaces: BlogReaderInterface
}

embedded {
Jolie:
	"blog_reader/main.ol" in BlogReader
}

init
{
	with( newsBlog ) { 
		.location = "socket://jolie-lang.blogspot.com:80/feeds/posts/default";
		.protocol = "http"
	};	
	with( planetBlogs[0] ) {
		.location = "socket://fmontesi.blogspot.com:80/feeds/posts/default/-/jolie";
		.protocol = "http"
	};
	with( planetBlogs[1] ) {
		.location = "socket://claudioguidi.blogspot.it:80/feeds/posts/default/-/jolie";
		.protocol = "http"
	}
}

main
{
	[ documentationMenu()( menu ) {
		f.filename = "../frontend/menu.json";
		f.format = "json";
		readFile@File( f )( menu );
		
		listRequest.directory = "../../www/content/documentation/jsl/";
		listRequest.regex = ".+\\.html";
		list@File( listRequest )( listResult );
		if ( #listResult.result > 0 ) {
			j = #menu.topics;
			apiTopic -> menu.topics[ j ];
			apiTopic.label = "Standard Library API";

			for( i = 0; z = 0, i < #listResult.result, i++ ) {
				match = listResult.result[ i ];
				match.regex = "(.+)\\.html";
				match@StringUtils( match )( matchResult );
				if ( matchResult.group[1] != "index" ) { // Do not include index.html
					apiTopic.children[ z ].label = matchResult.group[1];
					apiTopic.children[ z ].url = "jsl/" + matchResult.group[1];
					z++
				}
			}
		}
	} ] { nullProcess }

	[ getRss()( response ) {
		// getRss@NewsService()( response )
		nullProcess
	} ]{ nullProcess }
	
	[ news()( response ) {
		request.blogs -> newsBlog;
		readBlogs@BlogReader( request )( d );
		valueToPrettyString@StringUtils( d )( response )
	} ] { nullProcess }
	
	[ planet()( response ) {
		request.blogs -> planetBlogs;
		readBlogs@BlogReader( request )( d );
		valueToPrettyString@StringUtils( d )( response )
	} ] { nullProcess }
}