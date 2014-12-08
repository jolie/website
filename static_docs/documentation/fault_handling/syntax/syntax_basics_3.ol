interface identifer {
  RequestResponse:
    rr_name1( tk1 )( tk2 ) throws 	error_name11( error_type11 ) 
      error_name12( error_type12 ) 
      //...

    rr_name2( tk3 )( tk4 ) throws	error_name21( error_type21 )
      error_name22( error_type22 ) 
			//...

    rr_nameN( tkN )( tkN+1 ) throws 	error_nameN1( error_typeN1 ) 
      error_nameN2( error_typeN2 ) 
		  //...
}