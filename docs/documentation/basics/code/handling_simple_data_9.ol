a = 1;
undef( a );
if ( is_defined( a ) ) {
	println@Console( "a is defined" )()
} else {
	println@Console( "a is undefined" )()
}