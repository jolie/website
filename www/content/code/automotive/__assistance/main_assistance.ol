include "console.iol"
include "file.iol"
include "../config/config.iol"
include "./public/interfaces/AssistanceInterface.iol"

execution{ concurrent }

interface AssistanceUIInterface {
OneWay:
	setMessage( string )
}

outputPort AssistanceUI {
Protocol: sodep
Location: "local"
Interfaces: AssistanceUIInterface
}

embedded {
	Java:
		"com.italianasoftware.automotive.AutomotiveAssistanceJS" in AssistanceUI
}

inputPort Assistance {
Protocol: sodep
Location: Location_Assistance
Interfaces: AssistanceInterface
}

init
{
	getFileSeparator@File()( global.fileSeparator );
	getServiceDirectory@File()( global.serviceDirectory );
	println@Console("Running...")()

}

main 
{
	
	getOrchestrator( request )( response ){
		setMessage@AssistanceUI( "Received fault request from " + request.car_model );
		setMessage@AssistanceUI( "Fault type: " + request.fault  );
		setMessage@AssistanceUI( "Downloading orchestrator..." );
		if ( request.fault == "tyre") {
			file.filename = global.serviceDirectory + global.fileSeparator + "tyre.ol"
		} else {
			file.filename = global.serviceDirectory + global.fileSeparator + "default.ol"
		};
		readFile@File( file )( response );
		setMessage@AssistanceUI("Done!")
	}
}