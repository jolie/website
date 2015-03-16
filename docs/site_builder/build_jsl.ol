// Usage:
// jolie build_jsl.ol ../documentation/jsl $JOLIE_HOME/include/

include "exec.iol"
include "runtime.iol"
include "file.iol"
include "console.iol"
include "string_utils.iol"

execution{ concurrent }

interface DocumentationGenerator {
	RequestResponse: getFiles( string )( ListResponse )
	OneWay: generateDocumentation( void )
}

inputPort In {
	Location: "local"
	Interfaces: DocumentationGenerator
}

outputPort Self {
	Interfaces: DocumentationGenerator
}

init { 
	getLocalLocation@Runtime()( Self.location );
	getFileSeparator@File()( sep );
	generateDocumentation@Self() 
}

define generateIndex
{
	listRequest.regex = ".*\\.html";
	listRequest.directory = execRequest.workingDirectory;
	list@File( listRequest)( listResult );
	sortRequest.item -> listResult.result;
	sort@StringUtils( sortRequest )( sortRequest );
	listResult.result -> sortRequest.item;
	content = "<html><body><ul>";
	for( i = 0, i < #listResult.result, i++ ) {
		content += "<li><a href=\"" + listResult.result[i] + "\">" + listResult.result[i] + "</a></li>"
	};
	content += "</body></html>";
	file.filename = execRequest.workingDirectory + sep + "index.html";
	file.content -> content;
	writeFile@File( file )()
}

main
{
	[ getFiles( path )( getResult ){
	  // launch getFiles on sub-folders
		listRequest.directory = path;
		listRequest.dirsOnly = true;
		list@File( listRequest )( listResult );
		for( i = 0, i < #listResult.result, i++ ){
			// println@Console( "getting files from " + path + sep + listResult.result[ i ] )();
			getFiles@Self( path + sep + listResult.result[ i ] )( listResponse );
			for( j = 0, j < #listResponse.result, j++ ){
				// file = path + sep + listResult.result[ i ] + sep + listResponse.result[ j ];
				file = listResult.result[ i ] + sep + listResponse.result[ j ];
				// println@Console( "\t found file " + file )();
				getResult.result[ #getResult.result ] = file
			}
		};
		undef( listResult );
		undef( listRequest );
	  // add result to current folder files
		listRequest.directory = path;
		listRequest.regex = ".+\\.iol";
		list@File( listRequest )( listResult );
		for( i = 0, i < #listResult.result, i++ ){	
			getResult.result[ #getResult.result ] = listResult.result[ i ]
		}
	}]{ nullProcess }
	[ generateDocumentation() ] {
		if( args[0] == "" || args[1] == "" ) {
		  println@Console( "Received command to generate JSL documentation from \"" + args[ 0 ] + 
		  	"\"" + " to \"" + args[ 1 ] + "\"." + 
		  	"\n Wrong command, usage: jolie build_jsl.ol destination source" )()
		};
		install( IOException => println@Console( main.IOException )() );
		// getIncludePaths@Runtime()( paths );
		paths.path[0] = args[1];
		listRequest.regex = "[^\\.]+.*";
		execRequest = "joliedoc";
		execRequest.waitFor = 1;
		if ( is_defined( args[0] ) ) {
			execRequest.workingDirectory = args[0];
			// Check if the directory exists
			exists@File( args[0] )( exists );
			if ( !exists ) {
				mkdir@File( args[0] )( exists );
				if ( !exists ) {
					throw( IOException, "Could not create target directory" )
				}
			}
		} else {
			execRequest.workingDirectory = "."
		};
		execRequest.args[0] = "--outputPortEnabled";
		execRequest.args[1] = "true";
		for( i = 0, i < #paths.path, i++ ) {
			getFiles@Self( paths.path[ i ] )( listResult );
			for( j = 0, j < #listResult.result, j++ ) {
				execRequest.args[2] = //paths.path[i] + sep +
				listResult.result[j];
				exec@Exec( execRequest )( execResult );
				if( int(execResult.exitCode) > 0 ){
					println@Console( execResult + " " + execResult.exitCode + " " + execResult.stderr )()
				} else {
					print@Console( execResult )()
				}
			}
		};
	generateIndex;
	exit
	}	
}
