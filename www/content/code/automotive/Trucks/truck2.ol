include "truck_deploy.ol"

inputPort Truck2{
Protocol: sodep
Location: Location_Truck2
Interfaces: TruckInterface
}
init
{
	global.offset = 50;
	myLocation = Location_Truck2;
	Bank.location = Location_BankAE;
	global.counter = 0;
	with( account ) {
		.name = "Bono";
		.surname = "Vox";
		.CCnumber = "56789012"
	};
	services.( "truck_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "truck_main.ol"