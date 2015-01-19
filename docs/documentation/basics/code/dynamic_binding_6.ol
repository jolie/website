main
{
	with(laserPrinter) {
		.location = "socket://p1.com:80/"
		.protocol = "sodep"
	};

	with(inkJetPrinter) {
		.location = "socket://p2.it:80/"
		.protocol = "soap"
	}

    getBinding( name )( b ){
        if ( name == "LaserPrinter" ){
            b << laserPrinter
        } else if ( name == "InkJetPrinter" ) {
            b << inkJetPrinter
        }
    }
}