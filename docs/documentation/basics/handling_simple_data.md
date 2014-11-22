## Basic data types

Jolie is a dynamically typed language. It means that no type declaration is needed when assigning values to variables, which do not need to be declared in advance. Variables do not have a type associated with them and the type of their value is check at runtime.

Jolie supports seven basic data types:

- `bool`: booleans;
- `int`: integers;
- `long`: long integers:
- `double`: double-precision float;
- `string`: strings;
- `raw`: byte arrays;
- `void`: the empty type.

Although being a basic type, `raw` values cannot be created directly by the programmer, but are supported natively for data-passing purposes.

Furthermore, Jolie supports the `any` basic type, which means a value that can be any basic type.

Let us consider the following example in which differently typed values are passed into the same variable: 

<div class="code" src="handling_simple_data_3.ol"></div>

Jolie supports some basic arithmetic operators: add (`+`), subtract (`-`), multiply (`*`), divide (`/`) and modulo (`%`). Their behaviour is the same as in other classical programming languages. The language also supports pre-/post-increment (`++`) and pre-/post-decrement (`--`) operators.

An example of the aforementioned operators follows:

<div class="code" src="handling_simple_data_4.ol"></div>

---

## Casting and checking variable types

Variables can be cast to other types by using the corresponding casting functions: `bool()`, `int()`, `long()`, `double()`, and `string()`. Some examples follow:

<div class="code" src="handling_simple_data_1.ol"></div>

A variable type can be checked at runtime by means of the `instanceof` operator, whose syntax is:

<div class="syntax" src="syntax_handling_simple_data_1.ol"></div>

`instanceOf` operator can be used to check variable typing with both native types and custom ones (see type subsection in [Communication Ports](basics/communication_ports) section). Example:

<div class="code" src="handling_simple_data_2.ol"></div>

---

## Working with strings

Strings can be inserted enclosing them between double quotes. Character escaping works like in C and Java, using the `\` escape character:

<div class="code" src="handling_simple_data_5.ol"></div>

Strings can be concatenated by using the plus operator:

<div class="code" src="handling_simple_data_6.ol"></div>

String formatting is preserved, so strings can contain tabs and new lines:

<div class="code" src="handling_simple_data_7.ol"></div>

---

## Undefining variables

A variable is undefined until a value is assigned to them.

Checking if a variable is defined done by using the [is_defined](language_refences/is_defined) predicate, e.g.:

<div class="code" src="handling_simple_data_8.ol"></div>

Sometimes it is useful to undefine a variable, i.e. to remove its value and make it undefined again. 
Undefining a variable is done by using the [undef](language_references/undef) statement, as showed in the example below.

<div class="code" src="handling_simple_data_9.ol"></div>

---

## Dynamic arrays

[Arrays](http://en.wikipedia.org/wiki/Array_data_structure) in Jolie are [dynamic](http://en.wikipedia.org/wiki/Dynamic_array) and can be accessed by using the `[]` operator, like in many other languages.

Example:

<div class="code" src="handling_simple_data_10.ol"></div>

A key point for understanding and programming services in Jolie is that, 

<div class="attention"><p>in JOLIE every variable is a dynamic array.</p></div>

Jolie handles dynamic array creation and packing. This makes dealing with complex data easier, although Jolie hides this mechanism when the programmer doesn't need it. Whenever an array index is not specified, the implicit index for that variable is set by default to 0 (zero), like shown in the example below.

<div class="code" src="handling_simple_data_11.ol"></div>

### Array size operator `#`

Since its dynamic-array orientation, one handy feature provided by Jolie is the array size operator `#`, which can be used as shown in the examples below.

<div class="code" src="handling_simple_data_12.ol"></div>