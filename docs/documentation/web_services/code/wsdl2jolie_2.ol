include "PrimeNumbers.iol"
include "console.iol"

main
{
	request.max = 27;
	GetPrimeNumbers@PrimeNumbersSoap( request )( response );
	println@Console( response.GetPrimeNumbersResult )()
}