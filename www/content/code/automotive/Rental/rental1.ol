include "rental_deploy.ol"

inputPort Rental1 {
Protocol: sodep
Location: Location_Rental1
Interfaces: RentalInterface
}
init
{
	global.offset = 100;
	myLocation = Location_Rental1;
	Bank.location = Location_BankVISA;
	global.counter = 0;
	with( account ) {
		.name = "Mickey";
		.surname = "Mouse";
		.CCnumber = "76543210"
	};
	services.( "rental_recovering" ).price = 500 + global.offset;
	println@Console("Running...")()
}

include "rental_main.ol"