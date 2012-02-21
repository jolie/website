include "../config/config.iol"
include "./public/interfaces/GarageInterface.iol"
include "console.iol"

execution{ concurrent }

cset{ transactionId: BankCommitRequest.transactionId,
      reservationId: BankCommitRequest.reservationId
}

interface BankInterface {
RequestResponse:
	openTransaction throws AuthFailed InternalFault,
	payTransaction throws CreditLimit WrongAmount InternalFault
}


outputPort Bank {
Protocol: sodep
Interfaces: BankInterface
}