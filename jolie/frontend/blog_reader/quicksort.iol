include "BlogEntry.iol"

type QSType: void {
	.entry*:BlogEntry
}

interface QuicksortInterface {
RequestResponse: quicksort( QSType )( QSType )
}