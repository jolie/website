include "console.iol"
include "string_utils.iol"
include "runtime.iol"
include "time.iol"
include "quicksort_interface.iol"

execution{ concurrent }

inputPort SelfIn {
  Location: "local"
  Interfaces: ArticleQuickSortInterface
}

outputPort SelfOut{
  Interfaces: ArticleQuickSortInterface
}

init
{
 getLocalLocation@Runtime()( SelfOut.location )
}

main
{
	[ articleQuickSort( req )( res ){
 		if( #req.article == 1 ){
 			res << req
 		} else {
 			pivot = (#req.article)/2;
 			pivIt << req.article[ pivot ];
 			for ( i=0, i<#req.article, i++) {
 			  if( i != pivot ) {
				  if( req.article[ i ] > pivIt ) {
				    left.article[ #left.article ] << req.article[ i ]
				  } else {
				  	right.article[ #right.article ] << req.article[ i ]
				  }
 			  }
 			};
 			if( #left.article > 0 ) {
 				articleQuickSort@SelfOut( left )( qsLeft )
 			};
 			if( #right.article > 0 ){
 				articleQuickSort@SelfOut( right )( qsRight )
 			};
 			qsLeft.article[ #qsLeft.article ] << pivIt;
 			for ( i=0, i<#qsRight.article, i++) {
 			  qsLeft.article[ #qsLeft.article ] << qsRight.article[ i ]
 			};
 			res << qsLeft
 		}
 	 }]{ nullProcess } 
}