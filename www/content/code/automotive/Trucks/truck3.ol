include "truck_deploy.ol"

inputPort Truck3{
Protocol: sodep
Location: Location_Truck3
Interfaces: TruckInterface
}
init
{
	global.offset = 25;
	Bank.location = Location_BankVISA;
	myLocation = Location_Truck3;
	global.counter = 0;
	with( account ) {
		.name = "Elvis";
		.surname = "Presley";
		.CCnumber = "23456789"
	};
	services.( "truck_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "truck_main.ol"