include "console.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "time.iol"
include "atom_reader_interface.iol"

execution{ concurrent }

interface BlogInterface {
	RequestResponse: default(undefined)(undefined)
}

outputPort Blog {
	Interfaces: BlogInterface
}

// inputPort AtomNewsFetcher2 {
//   Location: "socket://localhost:8050"
//   Protocol: http
//   Interfaces: AtomNewsFetcherInterface
// }

inputPort AtomNewsFetcher {
	Location: "local"
  Interfaces: AtomNewsFetcherInterface
}

init
{
	blogs[0].location = "socket://fmontesi.blogspot.com:80/feeds/posts/";
	blogs[0].protocol = "http";
	blogs[1].location = "socket://claudioguidi.blogspot.it:80/feeds/posts/";
	blogs[1].protocol = "http"
}

define getNewsProcedure
{
	scope( fetch ){
		install( IOException => 
			println@Console( "IOException fetching " + Blog.location )();
			sleep@Time( 200 )();
			getNewsProcedure;
			println@Console( "Executed getNewsProcedure" )()
		);
	
  	date.regex = "(\\d{4})-(\\d{2})-(\\d{2})";
		entry -> atom.entry[ entryIdx ];
		for( Blog -> blogs[ blogIdx ]; blogIdx = 0, blogIdx < #blogs, blogIdx++ ) {
			default@Blog()( atom );
			for( entryIdx = 0, entryIdx < #atom.entry, entryIdx++ ) {	
				articleIndex = #response.article;
				with( response.article[ articleIndex ] ){
					.title = entry.title;
					.author = entry.author.name;
					if( entry.content.("@Attributes").type == "html" ) {
						.text = "<h1>" + entry.title + "</h1>" + entry.content
					} else { .text = "Unsupported content type."	};
					date = entry.updated;
					find@StringUtils( date )( aDate );
					response.article[ articleIndex ] = int( aDate.group[1] + aDate.group[2] + aDate.group[3] );
					.date = aDate.group[2] + "/" + aDate.group[3] + "/" + aDate.group[1]
				}
			}
		}
	}
}

main
{
	[ getNews( request )( response ){
		getNewsProcedure
	}]{ nullProcess }
}

