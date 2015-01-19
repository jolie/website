## Leonardo: the Jolie web server

Leonardo is a web server developed in pure Jolie [@M14].

It is very flexible and can scale from service simple static HTML content to supporting powerful dynamic web 
applications.

---

## Launching Leonardo and serving static content

The latest version of Leonardo is available from its SourceForge page, at URL: [http://sourceforge.net/projects/leonardo](http://sourceforge.net/projects/leonardo).

After having downloaded and unpacked the archive, we can launch Leonardo from the `leonardo` directory with the command `jolie leonardo.ol`.

By default Leonardo looks for static content to serve in the `leonardo/www` subdirectory. For example, we can store an `index.html` file in `www` subdirectory containing this simple HTML page:

<div class="code" src="leonardo_1.html"></div>

then, pointing the browser at URL http://localhost:8000/index we can see the web page we created. In the same way other files (of any format) and subdirectories can be stored inside the `www` directory: Leonardo makes them available to web browsers as expected.

---

## Configuration

Leonardo comes with a `config.iol` file, where are stored some constants for basic configuration. The content of the default `config.iol` file is shown below:

<div class="code" src="leonardo_2.ol"></div>

As aforementioned, `RootContentDirectory` points to the `www` folder, which is the default container of static pages, but it can also be overridden by declaring the new path as the first parameter in Leonardo execution command, e.g.,

`jolie leonardo.ol /path/to/my/content/directory`

---

## Serving dynamic content

Leonardo supports dynamic web application through the Jolie HTTP protocol. There are many ways this can be achieved, hereby we overview some of these:

- HTML querystring and HTML forms;
- via web development libraries like JQuery and Google Web Toolkit (GWT).

In the following examples we show how to interface a web application with some Jolie code through Leonardo. Specifically, we expose an operation - `length` - which accepts a list of strings, computes their total length and, finally, returns the computed value. 

We do this by editing the code inside Leonardo, while in real-world projects, it is recommended to separated the application logic and the web server one: this can be achieved with ease by creating a separate service and [aggregate](architectural_composition/aggregation) it from Leonardo's HTTP input port.

---

## Creating our web application: the application logic

We start by creating the Jolie code that serves the requests from the web interface.

Let us open `leonardo.ol` and add the following interface:

<div class="code" src="leonardo_3.ol"></div>

Then we edit the main HTTP input port, `HTTPInput`, and add `ExampleInterface` to the published interfaces:

<div class="code" src="leonardo_4.ol"></div>

Finally, we write the operation `length` by adding the code below to the input choice inside the `main` procedure in Leonardo:

<div class="code" src="leonardo_5.ol"></div>

The code above iterates over all the received items and sums their lengths.

---

## HTML querystrings

Once the server-side part is in place, we can start experimenting by invoking it from the browser, by pointing it to the address:

`http://localhost:8000/length?item=Hello&item=World`

which will reply with an XML response like the following:

`<lengthResponse>10</lengthResponse>`

Leonardo replies with XML responses by default, but the response can be formatted in fully-fledged HTML code by adding it in the code of operation `length` and setting the parameter `.format` inside input port `HTTPInput` as `html`.

Querystrings and other common message formats used in web applications, such as HTML form encodings, present the problem of not carrying type information. Instead, they simply carry string representations of values that were potentially typed on the invoker's side. However, type information is necessary for supporting services. To cope with such cases, Jolie introduces the notion of *automatic type casting*.

Automatic type casting reads incoming messages that do not carry type information and tries to cast their content values to the types expected by the service interface for the message operation.

---

## HTML forms

Operations can be invoked via HTML forms too.

Let us consider the following html page with a form which submits a request to the operation `length`:

<div class="code" src="leonardo_6.html"></div>

After it is stored in our `www` directory, we can navigate to: `http://localhost:8000/form.html` where we can find the form containing both a text input and a file input fields. If we write something in the text field and choose a file to upload for the file input one, we can submit the request to the operation `length` that will reply with the sum of the length of both the text and the content of the file.

---

## JQuery

Jolie fully supports asynchronous JavaScript and XML (AJAX) calls via XMLHttpRequest, which subsequently assures the support of most part of web application development libraries.

For the sake of brevity, we are not showing the boilerplate for building the HTML interface here, but it can be downloaded entirely from the link below:

<div class="download"><a href="documentation/web_applications/code/leonardo_code.zip">Leonardo and JQuery example</a></div>

Once downloaded and unpacked, we can launch leonardo and navigate to address `http://localhost:8000/`. Inside the `www` directory there are a `index.html` with a form containing three text fields - text1, text2, and text3. Submitting the request, by pressing the submit button, the event is intercepted by the JavaScript code shown below:

<div class="code" src="leonardo_7.js"></div>

The code is contained in library `jolie-jquery.js` stored inside the `lib` directory.

---

## Google Web Toolkit (GWT)

Jolie supports Google Web Toolkit too by means of the `jolie-gwt.jar` library stored inside the `lib` subdirectory of the standard trunk Jolie installation. Inside the library there is a standard GWT module, called JolieGWT, which must be imported into the GWT module we are using.

The module comes with support classes for invoking operations published by the service of Leonardo which is serving the GWT application. In our case, we can easily call the `length` operation with the following code:

<div class="code" src="leonardo_8.java"></div>

---

## References