myPets -> animals.pet;
println@Console( myPets[ 1 ].name )(); // will print dog
myPets[ 0 ].name = "bird"; // will replace animals.pet[ 0 ].name value with "bird"
println@Console( animals.pet[ 0 ].name )() // will print "bird"