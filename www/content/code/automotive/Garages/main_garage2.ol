include "garage_deploy.ol"

inputPort Garage2{
Protocol: sodep
Location: Location_Garage2
Interfaces: GarageInterface, CustomerInterface
}
init
{
	global.offset = 50;
	myLocation = Location_Garage2;
	Bank.location = Location_BankAE;
	global.counter = 0;
	with( account ) {
		.name = "Bertrand";
		.surname = "Russell";
		.CCnumber = "34567890"
	};
	services.( "garage_recovering" ).price = 500 + global.offset;
	services.( "on_the_fly_recoverig").price = 800 + global.offset;
	println@Console("Running...")()
}

include "garage_main.ol"