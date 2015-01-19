## HTTP GET/POST Requests

Let us focus on dealing with GET and POST request from web applications using the HTTP protocol directly (without [Leonardo](web_applications/leonardo.html)).

---

## Receiving GET requests

To receive and handle a GET requests. Let us consider a Jolie program that supports the sum of two numbers, `x` and `y`, by means of an operation called `sum`.

<div class="code" src="web_get_post_1.ol"></div>

Jolie transparently supports the reception of GET requests ad the automatic parsing of HTTP querystrings. Hence, we can simply execute `jolie sum.ol` and point the browser to: `http://localhost:8000/sum?x=6&y=2` to obtain the result of the sum computed by the code in our example.

---

## Sending GET requests

The `sum` service can be invoked from another Jolie program using a HTTP GET request. We can do this with the following client code:

<div class="code" src="web_get_post_2.ol"></div>

We use the `method` parameter of HTTP protocol to set our request method to GET.

---

## Receiving POST requests

Handling POST requests is similar to handling GET ones. Let us reuse the code given before for the `sum` service submitting a POST request: Jolie HTTP protocol implementation automatically detects a POST call and convert it to a standard message. Since POST calls are usually sent by browsers through HTML forms, we provide one by a simple extension of our `sum` service:

<div class="code" src="web_get_post_3.ol"></div>

This time we use the `format = "html"` HTTP parameter to support the dispatch of HTML responses by operation `form` which returns an HTML page containing a form that targets the `sum` operation. After executing the code and pointing the browser to `http://localhost:8000/form`, we should see an HTML form that submits the values `x` and `y` to operation `sum` and gets back a result.

---

## Sending POST requests

The difference between sending GET and POST requests stands in setting the `method` parameter. Let us modify the previous code used to shown how to send GET requests:

<div class="code" src="web_get_post_4.ol"></div>