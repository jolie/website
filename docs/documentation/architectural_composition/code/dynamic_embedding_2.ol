include "runtime.iol"

/*
	part of deployment omitted
*/

outputPort CounterService{
	Interfaces: CounterInterface
}

execution{ concurrent }

main
{
	startNewCounter( location );
	CounterClient.location = location;
	println@Console( "New counter session started" )();

	embedInfo.type = "Jolie";
	embedInfo.filepath = "CounterService.ol";
	loadEmbeddedService@Runtime( embedInfo )( CounterService.location );

	start@CounterService();
	while( true ){
		inc@CounterService()( counterState );
		receiveCount@CounterClient( counterState );
		sleep@Time( 1000 )()
	}
}