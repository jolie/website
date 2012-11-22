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
		
		j = #menu.topics;
		apiTopic -> menu.topics[ j ];
		apiTopic.label = "Standard Library API";
		listRequest.directory = "../../www/content/documentation/jsl/";
		list@File( listRequest )( listResult );
		for( i = 0; z = 0, i < #listResult.result, i++ ) {
			match = listResult.result[ i ];
			match.regex = "(.+)\\.html";
			match@StringUtils( match )( matchResult );
			if ( matchResult.group[1] != "index" ) {
				apiTopic.children[ z ].label = matchResult.group[1];
				apiTopic.children[ z ].url = "jsl/" + matchResult.group[1];
				z++
			}
		}
	} ] { nullProcess }
}