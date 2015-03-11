include "console.iol"
include "string_utils.iol"

execution{ concurrent }

type Name: void {
	.name: string
	.surname: string
}

type FaultType: void {
	.person: Name
}

type GetAddressRequest: void {
	.person: Name
}

type Address: void {
	.country: string
	.city: string
	.zip_code: string
	.street: string
	.number: string
}

type GetAddressResponse: void {
	.address: Address
}

interface MyServiceInterface {
RequestResponse:
	getAddress( GetAddressRequest )( GetAddressResponse ) 
		throws NameDoesNotExist( FaultType )
}

inputPort MyServiceSOAPPort {
	Location: "socket://localhost:8001"
	Protocol: soap
	Interfaces: MyServiceInterface
}

main {
	getAddress( request )( response ) {
		valueToPrettyString@StringUtils( request )( s );
		println@Console( "Received:" + s )();
		if (  request.person.name == "Homer" &&
			request.person.surname == "Simpsons" ) {
			with( response.address ) {
				.country = "USA";
				.city = "Springfield";
				.zip_code = "01101";
				.street = "Evergreen Terrace";
				.number = "742"
			}
		} else {
			with( fault.person ) {
				.name = request.person.name;
				.surname = request.person.surname
			};
			throw( NameDoesNotExist, fault )
		}
	}
}
