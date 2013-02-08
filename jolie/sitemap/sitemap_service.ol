include "console.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "sitemap_interface.iol"
include "runtime.iol"

inputPort MyLocal {
Location: "local"
Interfaces: SiteMapInterface
}

outputPort SiteMapService {
Interfaces: SiteMapInterface
}

execution { concurrent }

constants {
	SITE_FOLDER = "../../www/content"
}

init
{
	getLocalLocation@Runtime()( SiteMapService.location )
}

main
{
	[ sitemap()( response ){
		response = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">";
		listRequest.directory = SITE_FOLDER;
		list@File( listRequest )( listResponse );
		path -> listResponse.result[i];
		for( i=0, i<#listResponse.result, i++ ){
			length@StringUtils( path )( path_length );
			if ( path_length > 0 ){
				path.parent = SITE_FOLDER;
				exploreFolder@SiteMapService( path )( exResp );
				if( exResp ){
					response += exResp.result
				}
			}
		};
		response += "</urlset>"
	}]{ nullProcess }

	[ exploreFolder( path )( exResp ){
		exResp = false;
		isValidFile@SiteMapService( path )( is_valid_file );
		if ( is_valid_file ){
			exResp = true;
			exResp.result = "<url>
	<loc>" + is_valid_file.url + "</loc>
        <changefreq>monthly</changefreq>
    </url>"
		} else {
			path = path.parent + "/" + path;
			listRequest.directory = path;
			list@File( listRequest )( listResponse );
			subPath -> listResponse.result[ i ];
			for( i = 0, i < #listResponse.result, i++ ){
				tP = subPath;
				length@StringUtils( tP )( subPath_length );
				if ( subPath_length > 0 ){
					subPath.parent = path;
					exploreFolder@SiteMapService( subPath )( subExResp );
					if( subExResp ) {
						exResp = true;
						exResp.result += subExResp.result
					}
				}
			}
		}
	}]{ nullProcess }

	[ isValidFile( path )( is_valid_file ){
		is_valid_file = false;
		fR = path.parent + "/" + path;
		fR.regex = "(?:\\.\\./\\.\\./www/content)/([^\\:-\\?]+)/([^\\:-\\?]+)(?:.html)";
		find@StringUtils( fR )( fR );
		if( #fR.group > 0 ){
			is_valid_file = true;
			sMA = fR.group[ 2 ];
			tM = fR.group[ 1 ];
			undef( fR );
			fR = tM;
			fR.regex = "([^\\:-\\?]+)/([^\\:-\\?]+)";
			find@StringUtils( fR )( fR );
			if ( #fR.group > 2 ){
				tM = fR.group[ 1 ];
				sMA = fR.group[ 2 ] + "/" + sMA
			};
			is_valid_file.url = "%3Ftop_menu%3D" + tM;
			if ( tM != sMA ){
				is_valid_file.url += "%26sideMenuAction%3D" + sMA	
			}
		}
	}]{ nullProcess }
}
