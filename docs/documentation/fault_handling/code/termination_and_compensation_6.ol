include "console.iol"

main
{
	install( a_fault => 
		comp( example_scope )
	);
	scope( example_scope )
	{
		install( this => println@Console( "initiating recovery" )() );
		i = 1;
		while( true ){
			install( this =>
				cH;
				println@Console( "recovering step" + ^i )()
			);
			i++
		}
	}
	|
	throw( FaultName )
}