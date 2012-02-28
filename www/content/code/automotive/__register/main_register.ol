include "console.iol"
include "../config/config.iol"
include "./public/interfaces/RegisterInterface.iol"

execution{ concurrent }

inputPort Register {
Protocol: sodep
Location: Location_Register
Interfaces: RegisterInterface
}

init
{
	db -> global.db;
	with ( db.rental.row[0] ) {
		.name = "MickeyMouse Rental Service";
		.coord = "Mickey Mouse coordinates";
		.location = Location_RentalRedirector + "/!/rental1" //Location_Rental1
	};
	with ( db.rental.row[1] ) {
		.name = "Batman Rental Service";
		.coord = "Batman coordinates";
		.location = Location_RentalRedirector + "/!/rental2" //Location_Rental2
	};
	with ( db.rental.row[2] ) {
		.name = "Superman Rental Service";
		.coord = "Superman coordinates";
		.location = Location_RentalRedirector + "/!/rental3" //Location_Rental3
	};
	with ( db.garage.row[0] ) {
		.name = "Baudelaire Garage Service";
		.coord = "Baudelaire coordinates";
		.location = Location_GarageAggregator
	};
	with ( db.garage.row[1] ) {
		.name = "Bertrand Russel Garage Service";
		.coord = "Bertrand Russel coordinates";
		.location = Location_GarageAggregator
	};
	with ( db.garage.row[2] ) {
		.name = "Rene Descartes Garage Service";
		.coord = "Rene Descartes coordinates";
		.location = Location_GarageAggregator
	};
	with ( db.truck.row[0] ) {
		.name = "Michael Jackson Truck Service";
		.coord = "Michael Jackson coordinates";
		.location = Location_Truck1
	};
	with ( db.truck.row[1] ) {
		.name = "Bono Vox Truck Service";
		.coord = "Bono Vox coordinates";
		.location = Location_Truck2
	};
	with ( db.truck.row[2] ) {
		.name = "Elvis Presley Truck Service";
		.coord = "Elvis Presley coordinates";
		.location = Location_Truck3
	};
	println@Console("Running..")()
}

main
{
	lookFor( request )( response ){
		response -> db.( request.service );
		println@Console("Served lookFor")()
	}
}