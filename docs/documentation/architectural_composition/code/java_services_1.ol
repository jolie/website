initialize( request )( response-initialize ){ 
	scope( myScope ) {
		install( MyFault => println@Console( "Fault raised!" )() );
		response-initialize = "This is the initialization"; 
		throw( MyFault ) 
	}
}