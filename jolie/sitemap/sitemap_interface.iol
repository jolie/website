type Path: string {
	.parent: string
}

type ExResp: bool {
	.result?: string
}

type ValidResult: bool{
	.url?: string
}

interface SiteMapInterface {
	RequestResponse:
		sitemap( void )( string ),
		exploreFolder( Path )( ExResp ),
		isValidFile( Path )( ValidResult )
}