include "console.iol"
include "database.iol"
include "string_utils.iol"

execution { concurrent }

interface Todo {
RequestResponse:
	retrieveAll(void)(undefined),
	create(undefined)(undefined),
	retrieve(undefined)(undefined),
	update(undefined)(undefined),
	delete(undefined)(undefined)
}

inputPort Server {
	Location: "socket://localhost:8000/"
	Protocol: http { .format = "json" }
	Interfaces: Todo
}

init
{
	with (connectionInfo) {
		.username = "sa";
		.password = "";
		.host = "";
		.database = "file:tododb/tododb"; // "." for memory-only
		.driver = "hsqldb_embedded"
	};
	connect@Database(connectionInfo)();
	println@Console("connected")();

	// create table if it does not exist
	scope (createTable) {
		install (SQLException => println@Console("TodoItem table already there")());
		update@Database(
		    "create table TodoItem(id integer generated always as identity, " +
		    "text varchar(255) not null, primary key(id))"
		)(ret)
	}
}

main
{
	[ retrieveAll()(response) {
		query@Database(
			"select * from TodoItem"
		)(sqlResponse);
		response.values -> sqlResponse.row
	} ]
	[ create(request)(response) {
		update@Database(
			"insert into TodoItem(text) values (:text)" {
				.text = request.text
			}
		)(response.status)
	} ]
	[ retrieve(request)(response) {
		query@Database(
			"select * from TodoItem where id=:id" {
				.id = request.id
			}
		)(sqlResponse);
		if (#sqlResponse.row == 1) {
			response -> sqlResponse.row[0]
		}
	} ]	
	[ update(request)(response) {
		update@Database(
			"update TodoItem set text=:text where id=:id" {
				.text = request.text,
				.id = request.id
			}
		)(response.status)
	} ]
	[ delete(request)(response) {
		update@Database(
			"delete from TodoItem where id=:id" {
				.id = request.id
			}
		)(response.status)
	} ]
}
