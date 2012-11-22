include "frontend.iol"
include "file.iol"
include "string_utils.iol"
include "console.iol"

execution { concurrent }

inputPort FrontendInput {
Location: "local"
Interfaces: FrontendInterface
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
}