//server.ol
include "interface.iol"
include "console.iol"

inputPort Guess {
	Protocol: sodep
	Location: "socket://localhost:2000"
	Interfaces: GuessInterface
}

init {
	secret = 3
}

main
{
	install( FaultMain =>
		println@Console( "A wrong number has been sent!" )()
	);
	scope( num_scope )
	{
		install( NumberException =>
			println@Console( "Wrong number sent!" )();
			throw( FaultMain )
		);
		guess( number )( response ){
			if ( number == secret ) {
				println@Console( "Number guessed!" )();
				response = "You won!"
			} else {
				with( exceptionMessage ){
					.number = number;
					.exceptionMessage = "Wrong number, better luck next time!"
				};
				throw( NumberException, exceptionMessage )
			}
		}
	}
}