Value request = new Value();
request.getNewChild( "item" ).setValue( "Hello" );
request.getNewChild( "item" ).setValue( "World!" );
JolieService.Util.getInstance().call( 
	"length", 
	request,
	new AsyncCallback&lt;Value&gt; () {
		public void onFailure( Throwable t ) {}
		public void onSuccess( Value response )
		{
			Window.alert( response.strValue() );
		}
	});