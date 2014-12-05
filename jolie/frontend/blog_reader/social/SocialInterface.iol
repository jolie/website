type PostOnTwitterRequest: void {
	.status: string
}

interface SocialInterface {
RequestResponse:
	postOnTwitter( PostOnTwitterRequest )( void ) throws TwitterError
}
