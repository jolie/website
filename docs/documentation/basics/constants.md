## Constants

It is possible to define constants by means of the construct `constants`. The declarations of the constants are divided by commas. The syntax is:

<div class="syntax" src="syntax_constants_1.ol"></div>

As an example let us consider the following code:

<div class="code" src="constants_1.ol"></div>

Constants might also be assigned on the command line. Just call a program using `jolie -C server_location=\"socket://localhost:4003\" program.ol` to override `Server_location`. We can even remove its declaration from the `constants` list in case of a mandatory command line assignment.


<div class="panel panel-primary">
 	<div class="panel-heading">
  	<p class="panel-title">Attention</p>
  </div>
  <div class="panel-body">
    <p>Under Windows <code>=</code> is a parameter delimiter.</p>

    <p>To correctly use the command line option <code>-C</code> make sure to enclose the assignment of the constant between single or double quotes like <code>jolie -C "server_location=\"socket://localhost:4003\"" program.ol</code>.</p>
	</div>
</div>