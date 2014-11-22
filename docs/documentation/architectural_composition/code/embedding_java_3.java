package example;

import jolie.runtime.JavaService;
import jolie.runtime.Value;

public class Splitter extends JavaService {

	public Value splitter( Value s_msg ){
		String string = s_msg.getFirstChild("string");
		String regExpr = s_msg.getFirstChild("regExpr");
		
		String[] sa = string.split( regExpr );

		Value s_res = Value.create();
		
		for( String s : sa ){
			Value new_val = s_res.getNewChild( "s_chunk" );
			new_val.setValue( s );
		}

		return s_res; 
	}
}