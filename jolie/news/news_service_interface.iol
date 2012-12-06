type NewsRequest: void{
	.number?: int
}

type Article: void{
	.text: string
	.author: string
}

type EditArticle: void{
	.text: string
	.author: string
	.date: string
	.filename: string
}

type FileRequest: void{
	.filename: string
}

interface GetNewsInterface {
	RequestResponse:
		getNews( NewsRequest )( string ),
		getRss( NewsRequest )( string )
}

interface PostNewsInterface {
	RequestResponse:
		postNews( Article )( string ),
		deleteNews( FileRequest )( string ),
		getSingleNews( FileRequest )( string ),
		editArticle( EditArticle )( string ),
		newsAdmin( undefined )( string )
}