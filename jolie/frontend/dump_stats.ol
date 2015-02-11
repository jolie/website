include "runtime.iol"
include "string_utils.iol"
include "console.iol"
include "time.iol"

execution { sequential }

inputPort MyInput {
Location: "local"
OneWay: timeout( void )
}

init
{
	setNextTimeout@Time( 10 * 60 * 1000 ) // 10 minutes
}

main
{
	timeout();
	stats@Runtime()( stats );
	valueToPrettyString@StringUtils( stats )( s );
	println@Console( s )();
	setNextTimeout@Time( 1000 )
}