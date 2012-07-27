/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package jolie.example;

import jolie.net.CommChannel;
import jolie.net.CommMessage;
import jolie.runtime.JavaService;
import jolie.runtime.Value;
import jolie.runtime.embedding.RequestResponse;

/**
 *
 * @author claudio
 */
public class ThirdJavaService extends JavaService {

    public void start( Value msg ) {
        System.out.println( msg.getFirstChild("message").strValue() );
        Value v = Value.create();
        v.getFirstChild("message").setValue("Hello world from the Javaservice");
        try {
			CommMessage request = CommMessage.createRequest("initialize","/",v);
            CommMessage response = sendMessage( request ).recvResponseFor( request );
            System.out.println( response.value().strValue() );
		
        }
        catch ( Exception e ) {
            e.printStackTrace();
        }
    }

    @RequestResponse
    public Value write( Value msg ){
        System.out.println( msg.getFirstChild("message").strValue());
        Value v = Value.create();
         v.getFirstChild("message").setValue("Hello world from the write operation of the JavaService!");
        return v;
    }
}