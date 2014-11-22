importClass( java.lang.System );
importClass( java.lang.Integer );

function twice( request )
{
	var number = request.getFirstChild("number").intValue();
	System.out.println( "Received a 'twice' request for number: " + number );
	return Integer.parseInt(number + number);
}