include "console.iol"
include "file.iol"
include "string_utils.iol"

interface pegdownServiceInterface {
  RequestResponse: markdownToHtml( string )( string )
}

outputPort PegdownService {
  Interfaces: pegdownServiceInterface
}

embedded {
  Java: "org.pegdownService" in PegdownService
}

main
{
	// aliases
	parentFolder -> response.result[ i ];
	filename -> inRes.result[ j ];

	getFileSeparator@File()( sep );
	root = ".." + sep + "documentation";
  list@File( { 
    .directory=root,
    .dirsOnly=true
	} )( response );
	for ( i=0, i<#response.result, i++ ) {
	  list@File( {
	    .directory = root + sep + parentFolder,
	    .regex = ".+\\.md"
			} )( inRes );
		for( j=0, j<#inRes.result, j++ ){
			file = root + sep + parentFolder + sep + filename;
			println@Console( file )();
			readFile@File( { .filename = file } )( content );
			markdownToHtml@PegdownService( content )( htmlContent );
			
			length@StringUtils( file )( pathLength );
			substring@StringUtils( file { 
    		.begin=0,
				.end=pathLength-3
				} )( file );
			writeFile@File( { 
    		.content=htmlContent,
		    .filename=file + ".html"
    		} )()
		}
	}
}