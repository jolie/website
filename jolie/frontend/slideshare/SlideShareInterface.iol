type GetSlideshowsByUserRequest: void {
      .username_for: string
}

type GetSlideshowsByUserResponse: string {
      .Name: string
      .Count: string
      .Slideshow*: string {
	      .Updated: string
	      .Description: string
	      .Format: string
	      .Embed: string
	      .Title: string
	      .Status: string
	      .Created: string
	      .SlideshowType: string
	      .ThumbnailURL: string
	      .Username: string
	      .ThumbnailSize: string
	      .ID: string
	      .ThumbnailSmallURL: string
	      .DownloadUrl: string
	      .Language: string
	      .InContest: string
	      .URL: string
	      .Download: string
      } 
}


interface SlideShareInterface {
RequestResponse:
      get_slideshows_by_user( GetSlideshowsByUserRequest )( GetSlideshowsByUserResponse )
}