

define abort_transaction 
{
	query = "UPDATE transactions SET operation=0 WHERE id=" + transactionId;
	perform_update
}

main
{
	scope( ndchoice )
	{
		
		install( AuthFailed => 	abort_transaction );	
		install( InternalFault => 
			abort_transaction;
			println@Console("! - InternalFault, database error! ")()
		);
		install( CreditLimit => nullProcess );
		install ( WrongAmount => 
			abort_transaction;
			println@Console("! - Fault: WrongAmount. Aborted transaction id:" + transactionId )()
		);
		install( VerificationFailed => println@Console("! - Fault: VerificationFailed")());
		
		[ checkAvailability( request )( ) {
			println@Console("! - received checkAvailability request" )();
			scope( check ){
				install( AuthFailed => throw( VerificationFailed ));
				install( DBFault => throw ( VerificationFailed ));
			
				checkAvailability@BankAccount( request )()
			}
		}] { nullProcess }
		
		[ openTransaction( request )( response ) {
			scope( open ) {
				install( DBFault => throw( InternalFault ) );
				// authenticate account
				scope( ver ) {
					install( AuthFailed => 
						println@Console("AuthFailed in openTransaction for CCnumber:"+request.account.CCnumber)();
						throw( AuthFailed )
					);
					authAccount@BankAccount( request.account )( )
				};
				println@Console( "!  - verified account for CCnumber:" + request.account.CCnumber )();
				// create a transaction in the DB
        synchronized ( db_lock ) {
          global.db.id++;
          global.db.transaction[ global.db.id ].id = global.db.id;
          global.db.transaction[ global.db.id ].CCnumber = request.account.CCnumber;
          transactionId = global.db.id;
          reqFile.filename = TR_FILE;
          reqFile.format = "xml";
          reqFile.content -> global.db;
          writeFile@File( reqFile )( resFile )
        };
				transaction.CCnumber = request.account.CCnumber;
				transaction.cset = request.cset;
				transaction.location = request.location;
				transaction.amount = request.amount;
				response.transactionId = transactionId;
				println@Console("! - opened transaction for cc number:"+ request.account.CCnumber + " transactionId:"+transactionId)()
			}
		} ] { 
			[ closeTransaction( request )( ){
				scope( closingTransaction ) {
					
					install ( DBFault => 
						comp( add );
						throw( InternalFault )
					);
					
					accReq.CCnumber = transaction.CCnumber;
					accReq.amount = transaction.amount;
					if ( request.amount != transaction.amount ) { 
						throw( WrongAmount )
					};
					scope( add ) {
						install( AuthFailed =>
							println@Console("Authenitication failed in closeTransaction for transactionId:" + transactionId )();
							throw( AuthFailed )
						);
						addAmount@BankAccount( accReq )();
						install( this => subAmount@BankAccount( accReq )() )
					};
					query = "UPDATE  transactions SET operation=" + transaction.amount 
						+ ", counterPartBank=\"" + request.counterPartBank + "\""
						+ ", counterPartTransaction=" + request.counterPartTransaction
						+ " WHERE id=" + transactionId;
					perform_update
				};
				
				bkCommitReq << transaction.cset;
				bkCommitReq.result = 1;				// success
				bkCommitReq.transactionId = transactionId;
				Customer.location = transaction.location;
				bankCommit@Customer( bkCommitReq );
				println@Console("! - closed transactionId:" + transactionId + ", sent bankCommit to "+transaction.location )()
			}] { nullProcess }
			
			[cancelTransaction( request )(){ 
				abort_transaction;
				bkCommitReq << transaction.cset;
				bkCommitReq.result = 0;
				bkCommitReq.transactionId = transactionId;
				Customer.location = transaction.location;
				bankCommit@Customer( bkCommitReq );
				println@Console("! - cancelled transactionId:" + transactionId + ", sent bankCommit to "+transaction.location )()
			}] { nullProcess }
		
		      }
		
		[ payTransaction( request )( ) {
			BankOut.location = request.bankLocation;
			
			// creating a transaction row
			query = "INSERT INTO transactions (CCnumber) VALUES (\""
				+ request.account.CCnumber +"\")" ;
			synchronized( lock ) {
				perform_update;
				query = "SELECT * FROM transactions ORDER BY id ASC";
				perform_query;
				transactionId = query_resp.row[#query_resp.row - 1].id
			};
			trReq.transactionId = request.transactionId;
			trReq.amount = request.amount;
			trReq.counterPartBank = myLocation;
			trReq.counterPartCCN = request.account.CCnumber;
			trReq.counterPartTransaction = transactionId;
			
			ckAvReq << request.account;
			ckAvReq.amount = request.amount;
			scope( check ) {
				install( AuthFailed =>
					println@Console("Authentication failed in payTransaction for transactionId:" + transactionId )();
					abort_transaction;
					throw( AuthFailed )
				);
				install( VerificationFailed =>
					println@Console("! - fault:Credit Limit in checkAvailability within payTransaction for cc number:" + request.account.CCnumber )();
					cancelTransaction@BankOut( trReq )();
					abort_transaction;
					println@Console("! - sending cancel transaction for transactionId:" + request.transactionId + ", to location:"+ BankOut.location)();
					throw( CreditLimit )
				);
				checkAvailability@BankAccount( ckAvReq )()
			};
			
			scope( perform_transaction ) {
				
				install( DBfault =>abort_transaction;
						{ comp( closingTransaction ) | comp( subtracting )  };
						throw( InternalFault )
				);

				// closing transaction
				scope( closingTransaction ) {
					closeTransaction@BankOut( trReq )();
					install( this => abortTransaction@BankOut( trReq )() )
				};
				
				// subtracting amount
				scope( subtracting ){
					subReq.CCnumber = request.account.CCnumber;
					subReq.amount = request.amount;
					subAmount@BankAccount( subReq )();
					install( this => addAmount@BankAccount( subReq )() )
				};
				
				query = "UPDATE  transactions SET operation=-" + request.amount 
						+ ", counterPartBank=\"" + request.bankLocation + "\""
						+ ", counterPartTransaction=" + request.transactionId
						+ " WHERE id=" + transactionId;
				perform_update
			};
				
			println@Console("!  - performed transaction " + transactionId )()

		}] { nullProcess }
		
		[abortTransaction( request )() {
			abort_transaction
		}] { nullProcess }
		
	}
	
}
