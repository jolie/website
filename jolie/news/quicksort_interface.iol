type AQSType: void {
	.article*: int {
		.article: string
	}
}

interface ArticleQuickSortInterface {
  RequestResponse: articleQuickSort( AQSType )( AQSType )
}