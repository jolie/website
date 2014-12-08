courier AggregatorPort {
	interface interface_id( request )[( response )] {
		// some code, if necessary
		// and eventually
		forward (outputPort_name( request ) | outputPort_name( request )( response ))
	}
}