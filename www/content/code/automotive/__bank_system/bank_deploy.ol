include "bankLocations.iol"
include "console.iol"


execution { concurrent }
cset{ transactionId: request.transactionId }

//------------INRERFACES--------------------------------------------
interface BankAccountInterface {
RequestResponse:
	authAccount throws AuthFailed DBFault,
	checkAvailability throws VerificationFailed AuthFailed DBFault,
	addAmount throws AuthFailed DBFault,
	subAmount throws AuthFailed DBFault,
	connect throws DBFault
}

interface DatabaseInterface {
RequestResponse:
        connect,
        query,
        update
}






//--------OUTPUTPORTS-------------------------------------------

outputPort BankOut {
	Protocol: sodep
	Interfaces: TransactionInterface
}

outputPort Customer {
	Protocol: sodep
	OneWay:
		bankCommit
}

outputPort Database {
	Interfaces: DatabaseInterface
}

 //---------EMBEDDING-------------------------------------------


embedded {
Java:
        "joliex.db.DatabaseService" in Database
}