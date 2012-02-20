include "rental_deploy.ol"

inputPort Rental3{
Protocol: sodep
Location: Location_Rental3
Interfaces: RentalInterface
}
init
{
	global.offset = 25;
	myLocation = Location_Rental3;
	Bank.location = Location_BankAE;
	global.counter = 0;
	with( account ) {
		.name = "Clark";
		.surname = "Kent";
		.CCnumber = "09876543"
	};
	services.( "rental_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "rental_main.ol"