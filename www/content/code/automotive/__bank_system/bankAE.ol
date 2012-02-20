include "bank_deploy.ol"


inputPort BankService {
	Location:	Location_BankAE
	Protocol:	sodep
	Interfaces: BankInterface, TransactionInterface
}

init
{
	println@Console("bankAE Running...")();
	scope( connection ) {
		install( InvalidDriver =>
				println@Console("-fault:InvalidDriver " + connection.InvalidDriver.stackTrace )();
				throw( DBFault )
		);
		install( ConnectionError =>
				println@Console("-fault:ConnectionError")();
				throw( DBFault )
		);
		
		with( request ) {
			.driver = "mysql";
			.host = "localhost";
			.database = "americanexpress";
			.username = "root";
			.password = "francesca"
		};
		myLocation = Location_BankAE;
		connect@Database( request )( response );
		connect@BankAccount( request )( response );
		println@Console("! - BankAE: connection with databases done!")()
	}
}

include "bank_main.ol"