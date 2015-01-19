include "console.iol"

main 
{
	animals.pet[0].name = "cat";
	animals.pet[1].name = "dog";
	animals.wild[0].name = "tiger";
	animals.wild[1].name = "lion";

	foreach ( category : animals ) {
		for ( i = 0, i < #animals.( category ), i++ ) {
			println@Console( "animals." + category + "[" + i + "].name = " + animals.( category )[i].name )()
		}
	}
}