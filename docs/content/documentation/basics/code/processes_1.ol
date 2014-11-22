//Server.ol

include "console.iol"
include "percentInterface.iol"

inputPort PercService {
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: PercentInterface
}

execution{ concurrent }

main
{
	install( TypeMismatch =>
				println@Console( "TypeMismatch: " + main.TypeMismatch )()
	);

	percent( request )( response ){
		response.percent_value = double( request.part )/request.total
	}
}
