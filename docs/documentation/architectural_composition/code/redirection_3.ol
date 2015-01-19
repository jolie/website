include "console.iol"
include "ui/ui.iol"
include "ui/Swing_ui.iol"

outputPort SubService {
Location: "socket://localhost:2000/"
Protocol: soap
}

outputPort SumService {
Location: "socket://localhost:2001/"
Protocol: soap
}

inputPort MyService {
Location: "socket://localhost:2002/"
Protocol: sodep
Redirects: 	
	Sub => SubService,
	Sum => SumService	
}

main
{	
	keepRunning = true;
	while ( keepRunning ) {
		showInputDialog@SwingUI( "available commands: " +
			"relocateSum, relocateSub, exit." )( command );
		if ( command == "relocateSum" ) {
			showInputDialog@SwingUI( "The current service location is: " +
				SumService.location + 
				"\nInsert the new 'SumService' location" )( location );
			SumService.location = location;
			println@Console( "New location set for SumService: " + 
				SumService.location )()
		};
		if ( command == "relocateSub" ) {
			showInputDialog@SwingUI( "The current service location is: " +
				SubService.location + 
				"\nInsert the new 'SubService' location" )( location );
			SubService.location = location;
			println@Console( "New location set for SubService: " +
				SubService.location )()
		};
		if ( command == "exit" ) {
			keepRunning = false
		}
	}
}