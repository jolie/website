include "runtime.iol"
include "string_utils.iol"
include "console.iol"
include "time.iol"

execution { concurrent }

constants {
	DumpTimeout = 5 * 60 * 1000 // 10 minutes
}

inputPort MyInput {
Location: "local"
OneWay: timeout( void )
}

init
{
	setNextTimeout@Time( DumpTimeout )
}

main
{
	timeout();
	stats@Runtime()( stats );
	valueToPrettyString@StringUtils( stats )( s );
	println@Console( s )();
	setNextTimeout@Time( DumpTimeout )
}