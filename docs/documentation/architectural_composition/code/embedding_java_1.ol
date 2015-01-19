interface MyConsoleInterface {
	OneWay: println( string )
}

outputPort MyConsole {
	Interfaces: MyConsoleInterface
}

embedded {
	Java: "example.MyConsole" in MyConsole
}

main
{
	println@MyConsole("Hello World!")
}