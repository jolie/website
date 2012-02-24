include "garage_deploy.ol"

inputPort Garage3{
Protocol: sodep
Location: Location_Garage3
Interfaces: GarageInterface, CustomerInterface
}
init
{
	global.offset = 25;
	myLocation = Location_Garage3;
	Bank.location = Location_BankVISA;
	global.counter = 0;
	with( account ) {
		.name = "Rene";
		.surname = "Descartes";
		.CCnumber = "12345678"
	};
	services.( "garage_recovering" ).price = 500 + global.offset;
	services.( "on_the_fly_recoverig").price = 800 + global.offset;
	println@Console("Running...")()
}

include "garage_main.ol"