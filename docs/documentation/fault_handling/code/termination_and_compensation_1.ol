include "console.iol"

main
{
	scope ( scope_name )
	{
		install( this => 
			println@Console( "This is the recovery activity for scope_name" )()
		);
		println@Console( "I am scope_name" )()
	}
	|
	throw( FaultName )
}