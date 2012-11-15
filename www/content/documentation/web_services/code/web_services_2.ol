include "myWS_jolieDocument.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "console.iol"

main
{
	with( request ) {
		.CityName = "Rimini";
		.CountryName = "Italy"
	};
	GetWeather@GlobalWeatherSoap( request )( response );
	r = response.GetWeatherResult;
	r.options.includeAttributes = true;
	xmlToValue@XmlUtils( r )( v );
	valueToPrettyString@StringUtils( v )( s );
	println@Console( s )()
}