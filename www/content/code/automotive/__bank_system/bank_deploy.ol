include "../config/config.iol"
include "console.iol"
include "database.iol"
include "./public/interfaces/CustomerInterface.iol"
include "./public/interfaces/BankInterface.iol"
include "./__bank_account/public/interfaces/BankAccountInterface.iol"

execution { concurrent }

cset{ transactionId: CloseTransactionRequest.transactionId
		     CancelTransactionRequest.transactionId
}


outputPort BankOut {
  Protocol: sodep
  Interfaces: BankInterface
}

outputPort Customer {
  Protocol: sodep
  Interfaces: CustomerInterface
}

