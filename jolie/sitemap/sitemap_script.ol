include "console.iol"
include "file.iol"
include "sitemap_interface.iol"

outputPort Self {
	Interfaces: SiteMapInterface
}

embedded {
Jolie:
	"sitemap_service.ol" in Self
}

main {
	sitemap@Self()( file.content );
	file.filename = "../../www/sitemap.xml";
	writeFile@File( file )()
}