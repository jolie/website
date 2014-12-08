include "console.iol"

type Split_req: void{
	.string: string
	.regExpr: string
}

type Split_res : void{
	.s_chunk*: string
}

interface SplitterInterface {
	RequestResponse: 	split( Split_req )( Split_res )
}

interface MyJavaExampleInterface {
	OneWay: start( void )
}

outputPort Splitter {
	Interfaces: SplitterInterface
}

outputPort MyJavaExample {
	Interfaces: MyJavaExampleInterface
}

inputPort Embedder {
	Location: "local"
	Interfaces: SplitterInterface
}

embedded {
	Java: 	"example.Splitter" in Splitter,
			"example.JavaExample" in MyJavaExample
}

main
{	
	start@MyJavaExample();
	split( split_req )( split_res ){
		split@Splitter( split_req )( split_res )
	}
}