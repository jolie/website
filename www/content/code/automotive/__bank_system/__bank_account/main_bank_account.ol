
define auth {
    scope( query ) {
      install( SQLException => throw( AuthFailed ) );

      q = "SELECT amount FROM accounts WHERE 
		CCnumber=:CCnumber
		AND name=:name
		AND surname=:surname";
      q.CCnumber = request.CCnumber;
      q.name = request.name;
      q.surname = request.surname;
      query@Database( q )( result );
      if ( #result.row == 0 ) { 
	      println@Console("! - Authentication requested for CCnumber " + request.CCnumber + ": failed!")();
	      throw( AuthFailed ) 
      };
      println@Console("! - Authentication requested for CCnumber " + request.CCnumber + ": success!")()	;
      amount = result.row[ 0 ].amount
    }
}

init {
  install( AuthFailed => nullProcess );
  install( VerificationFailed => nullProcess );
  install( AccountNotFound => nullProcess )
}

main {	
      [ authAccount( request )( ){
	  auth
      }] { nullProcess }
      
      [ checkBankAccountAvailability( request )( ){
	  auth;
	  if ( result.row[0].amount < request.amount ) { 
		  println@Console("! - checkAvailability requested for CCnumber " + request.CCnumber + ": failed!")();
		  throw( VerificationFailed ) 
	  };
	  println@Console("! - checkAvailability requested for CCnumber " + request.CCnumber + ": success!")() 
      }]{ nullProcess }
      
      [ addAmount( request )( ){
	    auth;
	    undef( q );
	    scope( query ) {
	      install( SQLException => throw( AuthFailed ) );

	      q = "UPDATE accounts SET amount=:amount WHERE CCnumber=:CCnumber";
	      q.CCnumber = request.CCnumber;
	      q.amount = amount + request.amount;
	      update@Database( q )( result );
	      
	      println@Console("! - addAmount (" + request.amount + ") requested for CCnumber " + request.CCnumber + ": success!")()
	    }
	      
      }] { nullProcess }
      
      [ subAmount( request )( ) {      
	    auth;
	    undef( q );
	    scope( query ) {
	      install( SQLException => throw( AuthFailed ) );

	      q = "UPDATE accounts SET amount=:amount WHERE CCnumber=:CCnumber";
	      q.CCnumber = request.CCnumber;
	      q.amount = amount - request.amount;
	      update@Database( q )( result );
	      
	      println@Console("! - subAmount (" + request.amount + ") requested for CCnumber " + request.CCnumber + ": success!")()
	    }
      }] { nullProcess }
}