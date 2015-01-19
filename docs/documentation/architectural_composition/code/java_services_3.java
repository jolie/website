CommMessage response = sendMessage( request ).recvResponseFor( request ); 
if ( response.isFault() ) { 
	System.out.println( response.fault().faultName() ); 
} else { 
	System.out.println( response.value().strValue() ); 
}