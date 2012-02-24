include "../config/config.iol"
include "./public/interfaces/GarageInterface.iol"
include "../__bank_system/public/interfaces/CustomerInterface.iol"
include "../__bank_system/public/interfaces/BankInterface.iol"
include "console.iol"
include "string_utils.iol"

execution{ concurrent }

interface AggregatorInterface {
RequestResponse:
  shutdown
}

type GarageName:void {
	.garage_name:string
}

interface extender GarageInterfaceExtender {
RequestResponse:
	*( GarageName )( void ) throws GarageNotExists
OneWay:
	*( GarageName )
}

outputPort Garage1 {
Protocol: sodep
Location: Location_Garage1
Interfaces: GarageInterface
}

outputPort Garage2 {
Protocol: sodep
Location: Location_Garage2
Interfaces: GarageInterface
}

outputPort Garage3 {
Protocol: sodep
Location: Location_Garage3
Interfaces: GarageInterface
}

inputPort GarageAggregator {
Protocol: sodep
Location: Location_GarageAggregator
Interfaces: AggregatorInterface
Aggregates: { Garage1, Garage2, Garage3 } with GarageInterfaceExtender
}

courier GarageAggregator {
	[ interface GarageInterface( request )( response ) ] {
		if ( request.garage_name =="Baudelaire Garage Service" ) {
			forward Garage1( request )( response )
		} else if ( request.garage_name == "Bertrand Russel Garage Service" ) {
			forward Garage2( request )( response )
		} else if ( request.garage_name == "Rene Descartes Garage Service" ) {
			forward Garage3( request )( response )
		}		
	}
}

main {
  shutdown( request )( response ) {
    exit
  }
}