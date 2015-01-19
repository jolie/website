main
{
	getBinding( name )( b ){
		if ( name == "LaserPrinter" ){
			b.location = "socket://p1.com:80/";
			b.protocol = "sodep"
		} else if ( name == "InkJetPrinter" ) {
			b.location = "socket://p2.it:80/";
			b.protocol = "soap"
		}
	}
}