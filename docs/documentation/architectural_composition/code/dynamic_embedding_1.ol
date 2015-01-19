/*
	part of deployment omitted
*/

outputPort CounterService{
	Interfaces: CounterInterface
}

embedded {
	Jolie: "CounterService.ol" in CounterService
}

execution{ concurrent }

main
{
	startNewCounter( location );
	CounterClient.location = location;
	println@Console( "New counter session started" )();
	start@CounterService();
	while( true ){
		inc@CounterService()( counterState );
		receiveCount@CounterClient( counterState );
		sleep@Time( 1000 )()
	}
}