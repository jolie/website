include "../locations.iol"
include "console.iol"

execution{ concurrent }

cset{
	transactionId: request.transactionId,
	reservationId: request.reservartionId
} 

interface BankInterface {
RequestResponse:
	openTransaction throws AuthFailed InternalFault,
	payTransaction throws CreditLimit WrongAmount InternalFault
}

interface RentalInterface {
RequestResponse:
	book throws BookFault,
	getPrice
OneWay:
	revbook, bankCommit, redirect
	
}


outputPort Bank {
Protocol: sodep
Interfaces: BankInterface
}