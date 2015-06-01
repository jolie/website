include "console.iol"
include "file.iol"

type TreeType: void{
  .file: string
  .tab?: string
}

interface TreeInterface {
  RequestResponse: tree( TreeType )( string )
}

service TreeInternalService
{
	Interfaces: TreeInterface
	main
	{
	  tree( req )( res ){
	  	exists@File( req.file )( reqExists );
	  	if ( reqExists ){
	  		if( !is_defined( req.tab ) ){
	  			res += req.file
	  		} else {
		  		res += req.tab + "├-- " + req.file
		  	};
	  		isDirectory@File( req.file )( isDir );
		  	if ( isDir ){
		  		getFileSeparator@File()( sep );
		  		lReq.order.byname = true;
		  		lReq.directory = req.file;
		  		list@File( lReq )( lRes );
		  		for (i=0, i<#lRes.result, i++) {
		  		  bReq.file = req.file + sep + lRes.result[ i ];
		  		  if( is_defined( req.tab ) ) {
		  		  	bReq.tab = req.tab + "|   "
		  		  } else {
		  		  	bReq.tab = "    "
		  		  };
		  		  tree@TreeInternalService( bReq )( bRes );
		  		  res += "\n" + bRes
		  		}
	  		}
		  } else {
		  	res = req.file + " does not exist"
		  }
	  }
	}
}

main
{
  tree@TreeInternalService( { .file = "/path/to/my/directory" } )( res );
  println@Console( res )()
}