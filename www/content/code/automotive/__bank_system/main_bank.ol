

init{
  install( AuthFailed => nullProcess );	
  install( CreditLimit => nullProcess );
  install ( WrongAmount => 
	  abort_transaction;
	  println@Console("! - Fault: WrongAmount. Aborted transaction id:" + transactionId )()
  );
  install( VerificationFailed => println@Console("! - Fault: VerificationFailed")())
}


main
{
	[ checkAvailability( request )( ) {
		println@Console("! - received checkAvailability request" )();
		scope( check ){
			install( AuthFailed => throw( VerificationFailed ));
		
			checkABankAccountvailability@BankAccount( request )()
		}
	}] { nullProcess }
	
	[ openTransaction( request )( response ) {
		scope( open ) {
			// generating transactionId and init session data
			csets.transactionId = new;
			account << request.account;
			amount = request.amount;
			Customer.location = request.location;
			correlation_data << request.correlation_data;

			// authenticate account
			scope( ver ) {
				install( AuthFailed => 
					println@Console("AuthFailed in openTransaction for CCnumber:"+request.account.CCnumber)();
					throw( AuthFailed )
				);
				authAccount@BankAccount( account )( )
			};
			println@Console( "!  - verified account for CCnumber:" + account.CCnumber )();
			println@Console("! - opened transaction for cc number:"+ account.CCnumber + " transactionId:" + csets.transactionId)();
			response.transactionId = csets.transactionId
		}
	} ] { 
		[ closeTransaction( request )( ){
			scope( closingTransaction ) {
				if ( request.amount != amount ) { 
					throw( WrongAmount )
				};
				scope( add ) {
					install( AuthFailed =>
						println@Console("Authenitication failed in closeTransaction for transactionId:" + transactionId )();
						throw( AuthFailed )
					);
					accReq.account -> account;
					accReq.amount = amount;
					addAmount@BankAccount( accReq )()
				}
			};
			
			bkCommitReq << correlation_data;
			bkCommitReq.result = true;				// success
			bkCommitReq.transactionId = csets.transactionId;
			bankCommit@Customer( bkCommitReq );
			println@Console("! - closed transactionId:" + transactionId + ", sent bankCommit to "+transaction.location )()
		}] { nullProcess }
		
		[ cancelTransaction( request )(){ 
			bkCommitReq << correlation_data;
			bkCommitReq.result = false;
			bkCommitReq.transactionId = csets.transactionId;
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
