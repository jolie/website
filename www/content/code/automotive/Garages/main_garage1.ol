include "garage_deploy.ol"

inputPort Garage1 {
Protocol: sodep
Location: Location_Garage1
Interfaces: GarageInterface, CustomerInterface
}
init
{
	global.offset = 100;
	myLocation = Location_Garage1;
	Bank.location = Location_BankAE;
	global.counter = 0;
	with( account ) {
		.name = "Charles";
		.surname = "Baudelaire";
		.CCnumber = "23456789"
	};
	services.( "garage_recovering" ).price = 500 + global.offset;
	services.( "on_the_fly_recoverig").price = 800 + global.offset;
	println@Console("Running...")()
}

include "garage_main.ol"