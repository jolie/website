include "types/Binding.iol"

type ReadBlogsRequest:void {
	.blogs*:Binding
}

interface BlogReaderInterface {
RequestResponse:
	readBlogs( ReadBlogsRequest )( undefined )
}