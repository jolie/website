## Constants

It is possible to define constants by means of the construct `constants`. The declarations of the constants are divided by commas. The syntax is:

<div class="syntax" src="syntax_constants_1.ol"></div>

As an example let us consider the following code:

<div class="code" src="constants_1.ol"></div>

Constants might also be assigned on the command line. Just call your program using `jolie -C Server_location=\"socket://localhost:4003\" program.ol` to override `Server_location`. You can even remove its declaration from the `constants` list in case of a mandatory command line assignment.
