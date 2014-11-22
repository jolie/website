package example;

import jolie.runtime.JavaService;
import jolie.net.CommMessage;
import jolie.runtime.Value;

public class JavaServiceExample3 extends JavaService {
	public void start(Value msg){
		System.out.println( msg.getFirstChild("message").strValue() );
		Value v = Value.create();
		v.getFirstChild("message").setValue("Hello world from the JavaService");
		try{
			CommMessage response = sendMessage(new CommMessage("initialize", "/", v)).recv();
			System.out.println(response.value().strValue());
		} catch (Exception e){
			e.printStackTrace();
		}
	}
}