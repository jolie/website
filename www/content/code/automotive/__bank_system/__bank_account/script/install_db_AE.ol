include "database.iol"
include "runtime.iol"
include "console.iol"
include "file.iol"

define initDatabase
{
	i = 0;
	q.statement[i++] = "create table accounts (
		id integer generated always as identity primary key,
		name varchar(128) not null,
		surname varchar(128) not null,
		CCnumber varchar(128),
		amount integer
	)";
	q.statement[i++] = "INSERT INTO accounts (name, surname, CCnumber, amount ) VALUES ('Homer','Simpson','12345678',1000)";
	q.statement[i++] = "INSERT INTO accounts (name, surname, CCnumber, amount ) VALUES ('Charles','Baudelaire','23456789',1000)";
	q.statement[i++] = "INSERT INTO accounts (name, surname, CCnumber, amount ) VALUES ('Bertrand','Russell','34567890',1000)";
	executeTransaction@Database( q )()
}

main
{
	install( IOException => println@Console( main.IOException.stackTrace )() );
	install( ConnectionError => println@Console( main.ConnectionError )() );
	install( SQLException => println@Console( main.SQLException.stackTrace )() );

	loadLibrary@Runtime( "file:../lib/derby.jar" )();
	with( connectionInfo ) {
		.host = "";
		.driver = "derby_embedded";
		.port = 0;
		.database = "../database/data/bank_accountAE";
		.username = "";
		.password = "";
		.attributes = "create=true"
	};
	println@Console( "Creating database" )();
	connect@Database( connectionInfo )();
	println@Console( "Database created" )();

	initDatabase;
	println@Console( "Database initialised" )()
}