include "types/Binding.iol"

type ReadBlogsRequest:void {
	.blogs*:Binding
}

include "BlogEntry.iol"

type ReadBlogsResponse:void {
	.entry*:BlogEntry
}

interface BlogReaderInterface {
RequestResponse:
	readBlogs( ReadBlogsRequest )( ReadBlogsResponse )
}