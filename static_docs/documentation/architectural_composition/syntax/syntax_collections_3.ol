courier AggregatorPort {
	interface interface_id( request ) {
		// a forwarding condition
			forward ServiceOWOperation( request )
		// another forwarding condition
			forward ServiceRROperation( request )( response )
	}
}