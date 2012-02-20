include "../locations.iol"

interface CarOutInterface  {
OneWay:
	carFault
}

outputPort CarOut {
Location: Location_Car
Protocol: sodep
Interfaces: CarOutInterface
}

main
{
	request.fault = "tyre";
	carFault@CarOut( request )
}