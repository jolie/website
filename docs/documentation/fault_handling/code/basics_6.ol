scope ( s ){
	install( MyFault => 
		println@Console( "Caught MyFault, message: " + s.MyFault.msg )() 
	);
	faultMsg.msg = "This is all MyFault!";
	throw( MyFault, faultMsg )
};
println@Console( "Fault message from scope s: " + s.( s.default ).msg )()