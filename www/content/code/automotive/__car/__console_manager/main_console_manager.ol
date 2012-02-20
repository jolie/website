include "./public/interfaces/ConsoleManagerInterface.iol"
include "./public/surfaces/AutomotiveDialogSurface.iol"

include "console.iol"

execution{ sequential }

cset{ token: SelectionFromDialogRequest.token }

inputPort Test {
  Protocol: sodep
  Interfaces: ConsoleManagerInterface
  Location: "socket://localhost:8000"
}

inputPort ConsoleManager {
  Protocol: sodep
  Interfaces: ConsoleManagerInterface
  Location: "local"
}

init
{
	println@Console("ConsoleManager Running...")()
}
	
main
{	

    [ select( request )( response ){
	    csets.token = new;
	    request.token = csets.token;
	    selection@Dialog( request );
	    selectionFromDialog( selection_response );
	    for ( i=0, i<#request.row, i++ ) {
		    if( request.row[i].name == selection_response ) {
			    response = i
		    }
	    }
    }]{ nullProcess }
	
}