main
{
	// existing code in Leonardo
	[ length( request )( response ){
		response = 0;
		for( i = 0, i < #request.item, i++ ){
			length@StringUtils( request.item[ i ] )( l );
			response += l
		}
	}
	]{ nullProcess }
}