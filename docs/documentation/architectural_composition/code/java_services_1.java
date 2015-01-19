package Jolie.example;
import Jolie.net.CommChannel;
import Jolie.net.CommMessage;
import Jolie.runtime.JavaService;
import Jolie.runtime.Value;
import Jolie.runtime.embedding.RequestResponse;

public class ThirdJavaService extends JavaService { 
	public void start( Value msg ) { 
		System.out.println( msg.getFirstChild( "message" ).strValue() ); 
		Value v = Value.create();
		v.getFirstChild( "message" ).setValue( "Hello world from the JavaService" );
		try { 
			CommMessage request = CommMessage.createRequest( "initialize","/",v );
			CommMessage response = sendMessage( request ).
				recvResponseFor( request );
			System.out.println( response.value().strValue() ); 
			} catch ( Exception e ) {
				e.printStackTrace(); 
			}
		} 

	@RequestResponse public Value write( Value msg ){
		System.out.println( msg.getFirstChild( "message" ).strValue() );
		Value v = Value.create();
		v.getFirstChild( "message" )
			.setValue( "Hello world from the write operation of the JavaService!");
		return v;
	} 
}