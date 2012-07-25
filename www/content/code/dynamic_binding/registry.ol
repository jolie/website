execution { concurrent }

include "registry.iol"

inputPort MyInput {
Location: "socket://localhost:9000/"
Protocol: sodep
Interfaces: RegistryInterface
}

main
{
	getBinding( request )( response ) {
		if ( request == "LaserPrinter" ) {
			response.location = "socket://localhost:9001/"
		} else {
			response.location = "socket://localhost:9002/"
		};
		response.protocol = "sodep"
	}
}

