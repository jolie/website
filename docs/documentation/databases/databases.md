## Databases in Jolie

Jolie can be used with various relational/SQL databases, but per default only with one instance per program. The API is described here: http://docs.jolie-lang.org/#!documentation/jsl/Database.html. Please find attached the correct driver name and the JAR file to place under the `lib` directory (the program's one or the global one like `/usr/lib/jolie/lib/`).

Attention: if your JAR driver is called differently, you will have to rename it or create an apposite link, otherwise Jolie is not able to load it.

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

We as Jolie team provide only support for the listed DB systems, which were tested and are known to work. If your DB system has not been covered, please contact us (jolie-devel@lists.sourceforge.net) and we provide you the necessary help to get it added.
