interface identifier {
	OneWay: 
		ow_name1( t1 ), 
		ow_name2( t2 ), 
		//...,
		ow_nameN( tN )
	RequestResponse:
		rr_name1( tk1 )( tk2 ),
		rr_name2( tk3 )( tk4 ),
		//...
		rr_nameN( tkN )( tkN+1 )
}