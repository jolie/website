include "console.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "sitemap_interface.iol"

inputPort SiteMapService {
	//Location: "local"
	Location: "socket://localhost:8001"
	Protocol: http
	Interfaces: SiteMapInterface
}

//execution { concurrent }

constants {
	SITE_FOLDER = "../../www/content"
}

main
{
	//[ sitemap()( response ){
		listRequest.directory = SITE_FOLDER;
		list@File( listRequest )( listResponse );
		for(i=0,i<#listResponse.result,i++){
			respose += 
		};
		println@Console( response )()

	//}]{ nullProcess }

	[ exploreFolder( path )( expResponse ){
		listRequest.directory = path;
		list@File( listRequest )( listResponse )
	}]{
		nullProcess
	}
}
