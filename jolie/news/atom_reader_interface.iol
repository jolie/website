type FetchNewsRequest: void {
	.number?: int
}

interface AtomNewsFetcherInterface {
  RequestResponse: getNews( FetchNewsRequest )( undefined )
}