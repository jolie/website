include "console.iol"
include "file.iol"
include "string_utils.iol"
include "../config/config.iol"
include "./public/interfaces/AssistanceInterface.iol"

execution{ concurrent }


inputPort Assistance {
Protocol: soap {
	    .wsdl = "Assistance.wsdl";
            .wsdl.port = "AssistanceServicePort" 
	  }
Location: Location_Assistance
Interfaces: AssistanceInterface
}

inputPort AssistanceEmbedded {
Protocol: sodep
Location: "local"
Interfaces: AssistanceInterfaceEmbedded
}

init
{
	getFileSeparator@File()( global.fileSeparator );
	getServiceDirectory@File()( global.serviceDirectory );
	println@Console("Running...")()

}

main 
{
	
	[ getOrchestrator( request )( response ){
		max_index = #global.requests_vector;
		global.requests_vector[ max_index ] << request;
		global.requests_vector[ max_index ].image = "/images/delorean.jpg";
		if ( request.fault == "tyre") {
			file.filename = global.serviceDirectory + global.fileSeparator + "tyre.ol"
		} else {
			file.filename = global.serviceDirectory + global.fileSeparator + "default.ol"
		};
		readFile@File( file )( response.code )
	} ] { nullProcess }

	[ getRequests( )( response ) {
	   response.request -> global.requests_vector	  
	}] { nullProcess }

	[ getDetails( request )( response ) {
	  // simultate the data db retrieving of a car fault
	  // it always returns fake data
	  println@Console("retrieved fault of coordinates " + request.coord )();
	  response << global.requests_vector[ 0 ];
	  response.image = "/images/delorean.jpg";
	  response.name = "Homer";
	  response.surname = "Simpson";
	  response.address = "112 Blvd Street, Cesena(FC)"
	}] { nullProcess }
}