include "console.iol"
include "database.iol"
include "./public/interfaces/BankAccountInterface.iol"
include "runtime.iol"

execution{ concurrent }

//--- INPUT PORTS -------------------------------------------------------------------------

inputPort bankAccountService {
	Location: "local"
	Interfaces : BankAccountInterface
	Protocol: sodep
}

//--- INIT-------------------------------------------------------------------------

init
{
      loadLibrary@Runtime( "file:lib/derby.jar" )();
      scope( ConnectionScope ) {
	install( IOException => println@Console( ConnectionScope.IOException.stackTrace )() );
	install( ConnectionError => println@Console( ConnectionScope.ConnectionError.stackTrace )() );
	with( connectionInfo ) {
		.host = "";
		.driver = "derby_embedded";
		.port = 0;
		.database = "./database/data/bank_accountVISA";
		.username = "";
		.password = ""
	};
	 println@Console("ACCOUNT MANAGER: connecting with " + connectionInfo.database + "...")();
	connect@Database( connectionInfo )();
	println@Console("ACCOUNT MANAGER: connection with " + connectionInfo.database + " done.")()
  }
}

include "main_bank_account.ol"