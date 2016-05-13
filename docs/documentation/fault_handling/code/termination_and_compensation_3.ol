include "console.iol"
include "time.iol"

main
{
	scope( scope_name )
	{
		println@Console( "step 1" )();
		install( this => println@Console( "recovery step 1" )() );
		sleep@Time( 1 )();
		println@Console( "step 2" )();
		install( this => println@Console( "recovery step 2" )() );
		sleep@Time( 2 )();
		println@Console( "step 3" )();
		install( this => println@Console( "recovery step 3" )() );
		sleep@Time( 3 )();
		println@Console( "step 4" )();
		install( this => println@Console( "recovery step 4" )() )
	}
	|
	sleep@Time( 3 )();
	throw( FaultName )
}