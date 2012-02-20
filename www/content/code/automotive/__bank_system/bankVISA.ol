
include "bank_deploy.ol"


inputPort BankService {
	Location:	Location_BankVISA
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
			.database = "databasevisa";
			.username = "root";
			.password = "francesca"
		};
		myLocation = Location_BankVISA;
		connect@Database( request )( response );
		connect@BankAccount( request )( response );
		println@Console("! - BankVISA: connection with databases done!")()
	}
}


include "bank_main.ol"