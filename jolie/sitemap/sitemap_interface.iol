type expResponse: void {
	result*: string
}

interface SiteMapInterface {
	RequestResponse:
		sitemap( void )( string ),
		exploreFolder( string )( expResponse )
}