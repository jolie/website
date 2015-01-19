main
{
	getTemperature@Forecast( city )( temperature ) |
	getData@Traffic( city )( traffic );

	println@Console( "Request served!" )()
}