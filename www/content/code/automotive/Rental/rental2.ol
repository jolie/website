include "rental_deploy.ol"

inputPort Rental2{
Protocol: sodep
Location: Location_Rental2
Interfaces: RentalInterface
}
init
{
	global.offset = 50;
	myLocation = Location_Rental2;
	Bank.location = Location_BankVISA;
	global.counter = 0;
	with( account ) {
		.name = "Batman";
		.surname = "Batman";
		.CCnumber = "24680246"
	};
	services.( "rental_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "rental_main.ol"