[ buy( stock )( response ) {
	buy@Exchange( stock )( response )
} ] { println@Console( "Buy order forwarded" )() }

[ sell( stock )( response ) {
	sell@Exchange( stock )( response ) 
}] { println@Console( "Sell order forwarded" )() }