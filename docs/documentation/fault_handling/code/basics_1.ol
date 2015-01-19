include "ui/ui.iol"
include "ui/swing_ui.iol"
include "console.iol"

main
{	
	install( fault_main => 
		println@Console( "A wrong number has been inserted!" )()
		);
	
	secret = 3;
	
	scope( num_scope ) 
	{	
		install( fault_number => 
			println@Console( "Wrong!" )();
			throw( fault_main )
		);
		
		showInputDialog@SwingUI( "Insert a number" )( number );
		if ( number == number_to_guess ) {
			println@Console("OK!")()
		} else {
			throw( fault_number )
		}
	}
}