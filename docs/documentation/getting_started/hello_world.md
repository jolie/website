## Hello World

A Jolie program defines a service. A service achieves complex tasks by composing other services. An example of a very simple service is the following:

<div class="code" src="hello_world_1.ol"></div>

The program above reads as:


- include the source file console.iol;
- send the message `"Hello, world!"` to the `println` operation of the `Console` service.
    
We can already see some characteristics of a Jolie program:

- we can include other source files by means of the `include` primitive;
- the entry point of a Jolie program is the `main` code block;
- we can send a message to a service with a native primitive (Line 4).

The last point differs from classical programming languages and is peculiar to Jolie: the `println@Console( "Hello, world!" )()` line is a [solicit-response](basics/communication_ports.html) statement, which is a communication primitive.

---

## Running a Jolie service

Jolie programs are saved in files named with the `.ol` extension. For example, we can save the code of the service above in a file called `myFirstJolieService.ol`. Then, we can run it by executing the following command:

<kbd>jolie myFirstJolieService.ol</kbd>

which will print the string `Hello, world!`.