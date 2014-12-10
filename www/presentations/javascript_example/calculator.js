function pow( request )
{
	var x = request.getFirstChild( "x" ).doubleValue();
	var y = request.getFirstChild( "y" ).doubleValue();
	print( "Calculating " + x + " to the power of " + y );
	return Math.pow( x, y );
}
