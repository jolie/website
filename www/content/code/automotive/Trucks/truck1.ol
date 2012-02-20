include "truck_deploy.ol"

inputPort Truck1 {
Protocol: sodep
Location: Location_Truck1
Interfaces: TruckInterface
}
init
{
	global.offset = 100;
	myLocation = Location_Truck1;
	Bank.location = Location_BankAE;
	global.counter = 0;
	with( account ) {
		.name = "Michael";
		.surname = "Jackson";
		.CCnumber = "45678901"
	};
	services.( "truck_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "truck_main.ol"