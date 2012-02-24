

init{
  install( AuthFailed => nullProcess );	
  install( CreditLimit => nullProcess );
  install( WrongAmount => nullProcess );
  install( VerificationFailed => nullProcess )
}


main
{
	[ checkAvailability( request )( ) {
		println@Console("! - received checkAvailability request" )();
		scope( check ){
			install( AuthFailed => throw( VerificationFailed ));
		
			checkBankAccountAvailability@BankAccount( request )()
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
			println@Console("! - closed transactionId:" + csets.transactionId + ", sent bankCommit to "+ Customer.location )()
		}] { nullProcess }
		
		[ cancelTransaction( request )(){ 
			bkCommitReq << correlation_data;
			bkCommitReq.result = false;
			bkCommitReq.transactionId = csets.transactionId;
			bankCommit@Customer( bkCommitReq );
			println@Console("! - cancelled transactionId:" + csets.transactionId + ", sent bankCommit to "+ Customer.location )()
		}] { nullProcess }
	
	      }
	
	[ payTransaction( request )( ) {
		BankOut.location = request.bank_location;
		scope( check ) {
			install( AuthFailed =>
				println@Console("Authentication failed in payTransaction for transactionId:" + transactionId )();
				throw( AuthFailed )
			);
			install( VerificationFailed =>
				println@Console("! - fault:Credit Limit in checkAvailability within payTransaction for cc number:" + request.account.CCnumber )();
				with( cancel_req ) {
				  .transactionId = request.transactionId
				};
				cancelTransaction@BankOut( cancel_req )();
				println@Console("! - sending cancel transaction for transactionId:" + request.transactionId + ", to location:"+ BankOut.location)();
				throw( CreditLimit )
			);
			ckAvReq.account << request.account;
			ckAvReq.amount = request.amount;
			checkBankAccountAvailability@BankAccount( ckAvReq )()
		};
		
		scope( perform_transaction ) {
			with( tr_req ) {
			  .transactionId = request.transactionId;
			  .amount = request.amount
			};

			// closing transaction
			scope( closingTransaction ) {
				with( close_req ) {
				  .transactionId = request.transactionId;
				  .amount = request.amount
				};
				closeTransaction@BankOut( close_req )()
			};
			
			// subtracting amount
			scope( subtracting ){
				subReq.account << request.account;
				subReq.amount = request.amount;
				subAmount@BankAccount( subReq )()
			}
		};
		println@Console("!  - performed transaction " + request.transactionId )()

	}] { nullProcess }		
	
}
