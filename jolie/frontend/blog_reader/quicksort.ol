include "runtime.iol"
include "quicksort.iol"

execution { concurrent }

inputPort QuicksortInput {
Location: "local"
Interfaces: QuicksortInterface
}

outputPort Self {
Interfaces: QuicksortInterface
}

init
{
	getLocalLocation@Runtime()( Self.location )
}

main
{
	[ quicksort( req )( res ){
		if( #req.entry == 1 ){
			res << req
		} else {
			pivot = (#req.entry)/2;
			pivIt << req.entry[ pivot ];
			for ( i=0, i<#req.entry, i++) {
			  if( i != pivot ) {
				  if( req.entry[ i ].timestamp > pivIt.timestamp ) {
				    left.entry[ #left.entry ] << req.entry[ i ]
				  } else {
				  	right.entry[ #right.entry ] << req.entry[ i ]
				  }
			  }
			};
			if( #left.entry > 0 ) {
				quicksort@Self( left )( qsLeft )
			};
			if( #right.entry > 0 ){
				quicksort@Self( right )( qsRight )
			};
			qsLeft.entry[ #qsLeft.entry ] << pivIt;
			for ( i=0, i<#qsRight.entry, i++) {
			  qsLeft.entry[ #qsLeft.entry ] << qsRight.entry[ i ]
			};
			res << qsLeft
		}
	 } ] { nullProcess } 
}