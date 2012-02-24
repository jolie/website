include "../config/config.iol"
include "./public/interfaces/RentalInterface.iol"
include "../__bank_system/public/interfaces/CustomerInterface.iol"
include "../__bank_system/public/interfaces/BankInterface.iol"
include "console.iol"

execution{ concurrent }

cset{ transactionId: BankCommitRequest.transactionId,
      reservationId: BankCommitRequest.reservationId
}


outputPort Bank {
Protocol: sodep
Interfaces: BankInterface
}