
define auth {
    scope( query ) {
      install( SQLException => println@Console( query.SQLException.stackTrace )(); throw( AuthFailed ) );

      q = "SELECT amount FROM accounts WHERE 
		CCnumber=:CCnumber
		AND name=:name
		AND surname=:surname";
      q.CCnumber = __CCnumber;
      q.name = __name;
      q.surname = __surname;
      query@Database( q )( result );
      if ( #result.row == 0 ) { 
	      println@Console("! - Authentication requested for CCnumber " + __CCnumber + ": failed!")();
	      throw( AuthFailed ) 
      };
      println@Console("! - Authentication requested for CCnumber " + __CCnumber + ": success!")()	;
      __amount = result.row[ 0 ].AMOUNT
    }
}

init {
  install( AuthFailed => nullProcess );
  install( VerificationFailed => nullProcess );
  install( AccountNotFound => nullProcess )
}

main {	
      [ authAccount( request )( ) {
	  __CCnumber = request.CCnumber;
	  __name = request.name;
	  __surname = request.surname;
	  auth
      }] { nullProcess }
      
      [ checkBankAccountAvailability( request )( ){
	  __CCnumber = request.account.CCnumber;
	  __name = request.account.name;
	  __surname = request.account.surname;
	  auth;
	  if ( __amount < request.amount ) { 
		  println@Console("! - checkAvailability requested for CCnumber " + request.account.CCnumber + ": failed!")();
		  throw( VerificationFailed ) 
	  };
	  println@Console("! - checkAvailability requested for CCnumber " + request.account.CCnumber + ": success!")() 
      }]{ nullProcess }
      
      [ addAmount( request )( ){
	    __CCnumber = request.account.CCnumber;
	    __name = request.account.name;
	    __surname = request.account.surname;
	    auth;
	    undef( q );
	    scope( query ) {
	      install( SQLException => throw( AuthFailed ) );

	      q = "UPDATE accounts SET amount=:amount WHERE CCnumber=:CCnumber";
	      q.CCnumber = request.account.CCnumber;
	      q.amount = __amount + request.amount;
	      update@Database( q )( result );
	      
	      println@Console("! - addAmount (" + request.amount + ") requested for CCnumber " + request.account.CCnumber + ": success!")()
	    }
	      
      }] { nullProcess }
      
      [ subAmount( request )( ) {    
	    __CCnumber = request.account.CCnumber;
	    __name = request.account.name;
	    __surname = request.account.surname;
	    auth;
	    undef( q );
	    scope( query ) {
	      install( SQLException => throw( AuthFailed ) );

	      q = "UPDATE accounts SET amount=:amount WHERE CCnumber=:CCnumber";
	      q.CCnumber = request.account.CCnumber;
	      q.amount = __amount - request.amount;
	      update@Database( q )( result );
	      
	      println@Console("! - subAmount (" + request.amount + ") requested for CCnumber " + request.account.CCnumber + ": success!")()
	    }
      }] { nullProcess }

      [ setAccount( request )( response ) {
	 q = "UPDATE accounts SET amount=:amount WHERE CCnumber=:CCnumber";
	 q.CCnumber = request.CCnumber;
	 q.amount = request.amount;
	 update@Database( q )( result )
      }] { nullProcess }

      [ getAccountAmount( request )( response ) {
	 q = "SELECT amount FROM accounts WHERE CCnumber=:CCnumber";
	 q.CCnumber = request;
	 query@Database( q )( result );
	 response = result.row.AMOUNT
      }] { nullProcess }
}