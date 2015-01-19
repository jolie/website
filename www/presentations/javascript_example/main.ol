include "calculator.iol"
include "console.iol"

outputPort Calculator {
Interfaces: CalculatorIface
}

embedded {
JavaScript:
	"calculator.js" in Calculator
}

main
{
	request.x = 2;
	request.y = 3;
	pow@Calculator( request )( result );
	println@Console( "The result is: " + result )()
}
