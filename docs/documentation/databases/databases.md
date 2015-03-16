## Databases in Jolie

Jolie can be used with various relational/SQL databases, using the Database service from the standard library. The API is described here: http://docs.jolie-lang.org/#!documentation/jsl/Database.html. The Database service uses JDBC, so you need the correct driver JAR placed in the `lib` subdirectory (the one of the program or the global one, e.g., `/usr/lib/jolie/lib/` in Linux).

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
