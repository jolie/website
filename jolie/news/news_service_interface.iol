type NewsRequest: void{
	.number?: int
}

type Article: void{
	.text: string
	.author: string
}

interface GetNewsInterface {
	RequestResponse:
		getNews( NewsRequest )( string )
}

interface PostNewsInterface {
	RequestResponse:
		postNews( undefined )( string )
}		