include "weatherService.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "database.iol"
include "console.iol"

/*
 * weatherServiceCallerSql.ol - stores weather data in a HSQLDB DB
 */

constants { City = "Bolzano", Country = "Italy" }

main
{
    // fetch weather
    with( request ) {
        .CityName = City;
        .CountryName = Country
    };
    GetWeather@GlobalWeatherSoap( request )( response );
    r = response.GetWeatherResult;

    // connect to DB
    with ( connectionInfo ) {
        .username = "sa";
        .password = "";
        .host = "";
        .database = "file:weatherdb/weatherdb"; // "." for memory-only
        .driver = "hsqldb_embedded"
    };
    connect@Database( connectionInfo )( void );

    // create table if it does not exist
    scope ( createTable ) {
        install ( SQLException => println@Console("Weather table already there")() );
        updateRequest =
            "CREATE TABLE weather(city VARCHAR(50) NOT NULL, " +
            "country VARCHAR(50) NOT NULL, data VARCHAR(1024) NOT NULL, " +
            "PRIMARY KEY(city, country))";
        update@Database( updateRequest )( ret )
    };

    // insert/update current record
    scope ( update ) {
        install ( SQLException =>
            updateRequest =
                "UPDATE weather SET data = :data WHERE city = :city " +
                "AND country = :country";
            updateRequest.city = City;
            updateRequest.country = Country;
            updateRequest.data = r;
            update@Database( updateRequest )( ret )
        );
        updateRequest =
            "INSERT INTO weather(city, country, data) " +
            "VALUES (:city, :country, :data)";
        updateRequest.city = City;
        updateRequest.country = Country;
        updateRequest.data = r;
        update@Database( updateRequest )( ret )
    };

    // print inserted content
    queryRequest =
        "SELECT city, country, data FROM weather " +
        "WHERE city=:city AND country=:country";
    queryRequest.city = City;
    queryRequest.country = Country;
    query@Database( queryRequest )( queryResponse );

    // HSQLDB needs the attributes to be upcased when requesting content
    println@Console("City: " + queryResponse.row[0].CITY)();
    println@Console("Country: " + queryResponse.row[0].COUNTRY)();
    println@Console("Data: " + queryResponse.row[0].DATA)();

    // shutdown DB
    update@Database( "SHUTDOWN" )( ret )
}
