foreach ( kind : animals ){
	for ( i = 0, i < #animals.( kind ), i++  ){
		println@Console( "animals." + kind + "[" + i + "].name = " +
							animals.( kind )[ i ].name )()
	}
}