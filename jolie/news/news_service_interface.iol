type NewsRequest:void {
	.number?:int
	.order?:string
	.from?:int
}

type MarkedReq:void {
	.text:string
}

interface GetNewsInterface {
	RequestResponse:
		getNews( NewsRequest )( string ),
		getRss( NewsRequest )( string )
}

interface MarkedInterface{
	RequestResponse:
		marked( MarkedReq )( string )
}

interface ToMarkdownInterface{
	RequestResponse:
		convertToMarkdown( MarkedReq )( string )
}