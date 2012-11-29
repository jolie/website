type NewsRequest: void{
	.number?: int
}

interface GetNewsInterface {
	RequestResponse:
		getNews( NewsRequest )( string )
}

interface PostNewsInterface {
	RequestResponse:
		postNews( undefined )( string )
}		