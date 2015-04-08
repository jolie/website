with ( a.b.c ){
	.d[ 0 ] = "zero";
	.d[ 1 ] = "one";
	.d[ 2 ] = "two";
	.d[ 3 ] = "three"
};
currentElement[ 0 ] -> a.b.c.d[ i ];

for ( i = 0, i < #a.b.c.d, i++ ){
	println@Console( currentElement )()
}