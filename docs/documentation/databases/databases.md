## Databases in Jolie

Jolie can be used with various relational/SQL databases, using the Database service from the standard library. The API is described [here](jsl/Database.html). The Database service uses JDBC, so you need the correct driver JAR placed in the `lib` subdirectory (the one of the program or the global one, e.g., `/usr/lib/jolie/lib/` in Linux).

Attention: if your JAR driver is called differently, you will have to rename it or create an apposite link, otherwise Jolie is not able to load it. The list of correct names for JAR drivers is given below.

<table border>
    <tr>
	<th>Database</th>
	<th>Driver name (<code>driver</code>)</th>
	<th>JAR filename</th>
    </tr>
    <tr>
	<td>PostgreSQL</td>
	<td><code>postgresql</code></td>
	<td><code>jdbc-postgresql.jar</code></td>
    </tr>
    <tr>
	<td>MySQL</td>
	<td><code>mysql</code></td>
	<td><code>jdbc-mysql.jar</code></td>
    </tr>
    <tr>
	<td>Apache Derby</td>
	<td><code>derby_embedded</code> or <code>derby</code></td>
	<td><code>derby.jar</code> or <code>derbyclient.jar</code></td>
    </tr>
    <tr>
	<td>SQLite</td>
	<td><code>sqlite</code></td>
	<td><code>jdbc-sqlite.jar</code></td>
    </tr>
    <tr>
	<td>SQLServer</td>
	<td><code>sqlserver</code></td>
	<td><code>sqljdbc4.jar</code></td>
    </tr>
    <tr>
	<td>HSQLDB</td>
	<td><code>hsqldb_hsql</code>, <code>hsqldb_hsqls</code>, <code>hsqldb_http</code> or <code>hsqldb_https</code></td>
	<td><code>hsqldb.jar</code></td>
    </tr>
    <tr>
	<td>IBM DB 2</td>
	<td><code>db2</code></td>
	<td><code>db2jcc.jar</code></td>
    </tr>
    <tr>
	<td>IBM AS 400</td>
	<td><code>as400</code></td>
	<td><code>jt400.jar</code></td>
    </tr>
</table>

The Database service officially supports only the listed DB systems, which were tested and are known to work. If your DB system has not been covered, please contact us (jolie-devel@lists.sourceforge.net) and we will help you to get it added.

### Using multiple databases

By default, the Database service included by `database.iol` works for connecting to a single database. If you need to use multiple databases from the same Jolie service, you can run additional instance by creating another output port and embedding the Database Java service again, as in the following:

<div class="code" src="multiple_databases.ol"></div>

---

### First example: WeatherService

This is a modification of the WeatherService client mentioned in section [Web Services/web_services] (web_services/web_services.html). It fetches meteorologic data of a particular location (constants `City` and `Country`) and stores it in HSQLDB. If the DB has not been set up yet, the code takes care of the initialisation. The idea is to run the program in batch (eg. by a cronjob) to collect data, which could be interesting in Internet of Things (IoT) scenarios.

<div class="code" src="weatherServiceCallerSql.ol"></div>

### Second example: TodoList

The next example provides a very easy CRUD (create, retrieve, update, delete) webservice for a TODO list. The example is shown with HSQLDB but theoretically each DB could have been used. The HTTP's server output format is set to JSON, the input can be approached by both GET or POST requests.

<div class="code" src="todoWebservice.ol"></div>

Client requests using curl:
- Create new record: `curl -v "http://localhost:8000/create?text=Shopping"`
- Retrieve all records: `curl -v "http://localhost:8000/retrieveAll"`
- Retrieve record - GET in x-www-form-urlencoded (webbrowser form): `curl -v "http://localhost:8000/retrieve?id=0"`
- Retrieve record - GET request in JSON: `curl -v "http://localhost:8000/retrieve?=\{\"id\":0\}"`
- Retrieve record - POST request in x-www-form-urlencoded (webbrowser form): `curl -v -d "id=0" -H "Content-Type: application/x-www-form-urlencoded" "http://localhost:8000/retrieve"`
- Retrieve record - POST request in JSON: `curl -v -d "{\"id\":0}" -H "Content-Type: application/json" "http://localhost:8000/retrieve"`
