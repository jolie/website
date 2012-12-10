package example;

import jolie.runtime.JavaService;
import jolie.net.CommMessage;
import jolie.runtime.Value;
import jolie.runtime.ValueVector;

public class JavaExample extends JavaService {

	public void start(){
		String s_string = "a_steaming_coffee_cup";
		String s_regExpr = "_";

		Value s_req = Value.create();
		s_req.getNewChild("string").setValue(s_string);
		s_req.getNewChild("regExpr").setValue(s_regExpr);

		try {
			System.out.println("Sent request");
			CommMessage request = CommMessage.createRequest( 	"split", 
																"/", 
																s_req );
			CommMessage response = sendMessage( request ).recvResponseFor( request );
			System.out.println("Received response");

			Value s_array = response.value();
			ValueVector s_children = s_array.getChildren("s_chunk");
			for( int i = 0; i < s_children.size(); i++ ){
				System.out.println("\ts_chunk["+ i +"]: " + 
					s_children.get(i).strValue() );
			}

		} catch( Exception e ){
			e.printStackTrace();
		}
	}
}