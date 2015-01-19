interface MyConsoleInterface {
	OneWay:	println( string )
}

interface TwiceInterface {
	RequestResponse: 	twiceInt( int )( int ),
						twiceDoub( double )( double )
}

outputPort MyConsole {
	Interfaces: MyConsoleInterface
}

outputPort Twice {
	Interfaces: TwiceInterface
}

embedded {
	Java: 	"example.Twice" in Twice,
			"example.MyConsole" in MyConsole
}

main
{
	intExample = 3;
	doubleExample = 3.14;
	twiceInt@Twice( intExample )( intExample );
	twiceDoub@Twice( doubleExample )( doubleExample );
	println@MyConsole("intExample twice: " + intExample );
	println@MyConsole("doubleExample twice: " + doubleExample )
}