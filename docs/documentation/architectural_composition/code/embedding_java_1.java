package example;
import jolie.runtime.JavaService;

public class MyConsole extends JavaService {
	
	public void println( String s  ){
		System.out.println( s );
	}
}