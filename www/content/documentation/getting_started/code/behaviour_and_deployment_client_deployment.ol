include "console.iol"
include "twiceInterface.iol"

outputPort TwiceService {
	Location: "socket://localhost:8000"
	Protocol: sodep
	Interfaces: TwiceInterface
}