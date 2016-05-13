include "console.iol"

main
{
	install( a_fault => 
		println@Console( "Fault handler for a_fault" )();
		comp( example_scope )
	);
	scope( example_scope )
	{
		install( this => 
			println@Console( "recovering step 1" )()
		);
		println@Console( "Executing code of example_scope" )();
		install( this => 
			cH;
			println@Console( "recovering step 2" )()
		)
	};
	throw( FaultName )
}