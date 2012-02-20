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

interface GarageInterface {
RequestResponse:
/* book a service
*@request:void {
*	.name:string
*	.surname:string
*	.car_model:string
*	.plate: string
*	.serviceType:string
*	.bankLocation:string
*}
*@response:void {
*	.reservationId:string
*	.transactionId: string
*	.bankLocation:string
*	.amount:int
*}
*/
	book throws BookFault,

/* returns the requested price for a service
*@request:void {
*	.serviceType:string
*}
*@response:void {
*	.price:int
*}*/
	getPrice 

OneWay:
/* revokes a reservation
*@request:string // the reservation id
*/
	revbook, bankCommit
}


outputPort Bank {
Protocol: sodep
Interfaces: BankInterface
}