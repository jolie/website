/***************************************************************************
 *   Copyright (C) 2013 by Fabrizio Montesi <famontesi@gmail.com>          *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   For details about the authors of this software, see the AUTHORS file. *
 ***************************************************************************/

include "console.iol"
include "file.iol"
include "runtime.iol"
include "string_utils.iol"
include "ini_utils.iol"
include "registry/JpsrRegistry.iol"

execution { concurrent }

constants
{
	JpsrServiceDir = "services",
	JpsrTmpDir = "tmp",
	JpsrAuthAggregatorFile = "auth_aggregator.ol",
	ConfigFilename = "config.ini",
	BaseTargetServicePort = 9100
}

interface JpsrInterface {
RequestResponse: shutdown(void)(void)
}

inputPort JpsrInput {
Location: "local"
Interfaces: JpsrInterface
}

embedded {
Jolie:
	"account_manager/main.ol",
	"web/leonardo/leonardo.ol"
}

/* embedded {
Jolie:
	"registry/main.ol" in JpsrRegistry
} */

init
{
	println@Console( "Starting JPSR (Jolie Public Service Repository)" )()
}

init
{
	getServiceDirectory@File()( thisDir );
	targetServicePort = BaseTargetServicePort;
	tmpDir = thisDir + "/" + JpsrTmpDir;
	delete@File( tmpDir )();
	mkdir@File( tmpDir )();
	
	f.filename = thisDir + "/" + JpsrAuthAggregatorFile;
	readFile@File( f )( aggregatorCode )
}

init
{
	loadRequest.type = "Jolie";
	
	// Look for all subdirectories in the JPSR service directory
	listRequest.directory = thisDir + "/" + JpsrServiceDir;
	listRequest.dirsOnly = true;
	list@File( listRequest )( list );
	for( i = 0, i < #list.result, i++ ) {
		println@Console( "\t Found service directory: " + list.result[i] )();
		targetDir = listRequest.directory + "/" + list.result[i];
			
		// Read the service configuration
		parseIniFile@IniUtils( targetDir + "/config.ini" )( config );

		targetService = targetDir + "/" + config.JPSR.MainFile;
		targetServiceLocation = "socket://localhost:" + targetServicePort + "/";
		println@Console( "\t Loading service " + config.JPSR.Name + " with location " + targetServiceLocation )();
		
		targetOutputPortCode = 
			"outputPort JpsrService {\n" +
			"Interfaces: " + config.JPSR.Interface +
			"\n}\n";
		
		// Create the aggregator file in tmp
		w.content =
			"include \"file:" + targetDir + "/" + config.JPSR.InterfaceFile + "\"\n" +
			targetOutputPortCode + "\n" +
			aggregatorCode;
		w.filename = tmpDir + "/" + "aggregator" + targetServicePort + "_" + config.JPSR.Name + ".ol";
		writeFile@File( w )();
		
		// Load the aggregator for the target service
		loadRequest.filepath = 
			w.filename +
			" -C TargetService=\"" + targetService + "\"" +
			" -C Location_JpsrAggregator=\"" + targetServiceLocation + "\"" + 
			" -C TargetServiceInterface=\"" + config.JPSR.Interface + "\"";
		
		loadEmbeddedService@Runtime( loadRequest )( global.aggregatorLocs[i] );
		
		targetServicePort++
	}
}

main
{
	[ shutdown()() { nullProcess } ] {
		exit
	}
}
