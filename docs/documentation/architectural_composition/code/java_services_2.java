public class FourthJavaService extends JavaService { 
	private int counter; 

	public Value start( Value request ) { 
		counter++; 
		Value v = Value.create(); 
		v.setValue( counter ); return v; 
	}
}