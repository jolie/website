## Embedding a JavaScript Service

Embedding a JavaScript Service enables to use both the JavaScript language and Java methods by importing their classes.

Let us rewrite the [*twice* service example](architectural_composition/embedding_jolie.html) as a JavaScript embedded service.

<div class="code" src="embedding_javascript_1.js"></div>

At Lines 1-2 we respectively import `java.lang.System` to use it for printing at console a message, and `java.lang.Integer` to send a proper response to the embedder. This is necessary because of JavaScript's single number type which, internally, represents any number as a 64-bit floating point number.
At Line 6 the methods `getFirstChild` and `intValue`, belonging to `Value` class, are used to read the request's data. Finally at Line 8 we use the `parseInt` method of class `Integer` to return an `Integer` value to the invoker.

<div class="code" src="embedding_javascript_1.ol"></div>

Like embedding Jolie Services, also JavaScript Services require the specification of the local file where the JavaScript Service is defined (i.e., `TwiceService.js`, Line 18).