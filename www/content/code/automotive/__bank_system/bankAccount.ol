
include "console.iol"


execution{concurrent}

type RequestDataType: void {
	.name?:string
	.surname?:string
	.CCnumber:string
	.amount?:int
}
/*
 * types{
 * creditCardType {
 *	.type: string			
 *	.number:string
 *	.expirationDate:string
 *	.name=string
 *	.secretCode:string
 *	}
 * }
 * bankAccountType {
 * 	<< creditCardType
 *	.amount:int  		the total amount available for a given account
 *}
*/

//--- INTERFACES -------------------------------------------------------------------------

interface DatabaseInterface {
RequestResponse:
        connect,
        query,
        update
}

interface BankAccountInterface {
RequestResponse:
	/**
	 * Verifies the credentials of a given cc
	 * @request:void {
	 * 	<< creditCardType
	 * }
	 * @response:void 	the credentials are verified
	 * @throws AuthFailed 	the credentials are not verified
	 */
	authAccount throws AuthFailed DBFault,
	
	/**
	 * Verifies the amount availability of a given username
	 * @request:void {
	 * 	<< bankAccountType
	 * }
	 * @response:void 			the credentials are verified
	 * @throws VerificationFailed 	the credentials are not verified
	 */
	checkAvailability( RequestDataType )( undefined ) throws VerificationFailed AuthFailed DBFault,
	
	/**
	 * It adds an amount of money to the given cc number
	 * @request:void {
	 *	.CCnumber		credit card number
	 *     	.amount:int		amount to add
	 * }
	 * @response:void
	 * @throws AccountNotFound
	 */
	addAmount throws AuthFailed DBFault,
	
	/**
	 * It subtracts an amount of money to the given cc number
	 * @request:void {
	 * 	.ccData:void
	 *		.number	credit card number
	 *     .amount:int		amount to subtract
	 * }
	 * @response:void
	 * @throws AccountNotFound
	 */
	subAmount throws AuthFailed DBFault,
	
	/**
	 * It requires init data for DB connection
	 * @request:void {
	 * 	.driver: string //= "mysql";
	 *	.host: string // = "localhost";
	 *	.database: string 
	 *	.username: string 
	 *	.password: string 
	 * }
	 * @response:void
	 * @throws DBFault
	 */
	connect throws DBFault
	
}



//--- OUTPUT PORTS ---------------------------------------------------------------------

outputPort Database {
	Interfaces: DatabaseInterface
}


//--- EMBEDDED -------------------------------------------------------------------------

embedded {
Java:
        "joliex.db.DatabaseService" in Database
}

//--- INPUT PORTS -------------------------------------------------------------------------

inputPort bankAccountService {
	Location: "local"
	Interfaces : BankAccountInterface
	Protocol: sodep
}

//--- INIT-------------------------------------------------------------------------

init
{
        println@Console("BankAccount Running...")();
	
	connect( request )( response ) {
		
		scope( connection ) {
			install( InvalidDriver =>
					println@Console("-fault:InvalidDriver " + connection.InvalidDriver.stackTrace )();
					throw( DBFault )
			);
			install( ConnectionError =>
					println@Console("-fault:ConnectionError")();
					throw( DBFault )
			);
			
			/*with( request ) {
				.driver = "mysql";
				.host = "localhost";
				.database = "virtual_resources";
				.username = "tomcat";
				.password = "tomcat"
			};*/

			connect@Database( request )( response );
			println@Console("! - BankAccount: Connection with database done!")()
		}
	}
}


//--- MAIN -------------------------------------------------------------------------

define perform_query
{
        scope( sql ) {
                install( SQLException =>
                        println@Console("-fault: SQLException ")();
                        println@Console( sql.SQLException.stackTrace )();
                        throw( DBFault )
                );
                query@Database( query )( query_resp )
        }
}

define perform_update
{
        scope( sql ) {
                install( SQLException =>
                        println@Console("-fault: SQLException ")();
                        println@Console( sql.SQLException.stackTrace )();
                        throw( DBFault )
                );
                update@Database( query )( query_resp )
        }
}

main {

	scope( mainScope ){
	
		install( AuthFailed =>
				nullProcess
			);
		install( VerificationFailed =>
				nullProcess
			);
		install( AccountNotFound =>
				nullProcess
			);
		
		[authAccount( request )( ){
			
			query = "SELECT * FROM Account WHERE CCnumber = \"" + request.CCnumber 
				+ "\" AND name =\""  + request.name 
				+ "\" AND surname = \"" + request.surname + "\"" ;
			perform_query;
			if ( #query_resp.row == 0 ) { 
				println@Console("! - Authentication requested for CCnumber " + request.CCnumber + ": failed!")();
				throw( AuthFailed ) 
			};
			println@Console("! - Authentication requested for CCnumber " + request.CCnumber + ": success!")()
			      
		}] { nullProcess }
		
		[checkAvailability( request )( ){
			
			query = "SELECT * FROM Account WHERE CCnumber = \"" + request.CCnumber 
				+ "\" AND name =\""  + request.name 
				+ "\" AND surname = \"" + request.surname + "\"" ;
			perform_query;
			if ( #query_resp.row == 0 ) { 
				println@Console("! - checkAvailability: authentication requested for CCnumber " + request.CCnumber + ": failed!")();
				throw( AuthFailed )
			};
			if ( query_resp.row[0].amount < request.amount ) { 
				println@Console("! - checkAvailability requested for CCnumber " + request.CCnumber + ": failed!")();
				throw( VerificationFailed ) 
			};
			println@Console("! - checkAvailability requested for CCnumber " + request.CCnumber + ": success!")()
			
		}]{ nullProcess }
		
		[addAmount( request )( ){
			
			query = "SELECT amount FROM Account WHERE CCnumber = \"" + request.CCnumber + "\"";
			perform_query;
			if ( #query_resp.row == 0 ) { 
				println@Console("! - addAmount: authentication requested for CCnumber " + request.CCnumber + ": failed!")();
				throw( AuthFailed )
			};
			query = "UPDATE Account SET amount=" + string(int(query_resp.row[0].amount) + int(request.amount)) 
				+ " WHERE CCnumber= \"" + request.CCnumber + "\"";
			perform_update;
			println@Console("! - addAmount (" + request.amount + ") requested for CCnumber " + request.CCnumber + ": success!")()
			
		}] { nullProcess }
		
		[subAmount( request )( ){
			
			query = "SELECT amount FROM Account WHERE CCnumber = \"" + request.CCnumber + "\"";
			perform_query;
			if ( #query_resp.row == 0 ) { 
				println@Console("! - addAmount: authentication requested for CCnumber " + request.CCnumber + ": failed!")();
				throw( AuthFailed )
			};
			query = "UPDATE Account SET amount=" + string( int(query_resp.row[0].amount) - int(request.amount))
				+ " WHERE CCnumber= \"" + request.CCnumber + "\"";
			perform_update;
			println@Console("! - subAmount (" + request.amount + ") requested for CCnumber " + request.CCnumber + ": success!")()
			
		}] { nullProcess }
	}
}