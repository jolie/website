## Basic data types

Jolie is a dynamically typed language. It means that no type declaration is needed when assigning values to variables, which do not need to be declared in advance. Variables do not have a type associated with them and the type of their value is check at runtime.

Jolie supports seven basic data types:

- `bool`: booleans;
- `int`: integers;
- `long`: long integers (with `L` or `l` suffix);
- `double`: double-precision float (decimal literals);
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

Additional meanings: `+` is the string concatenator and matches the OR on `bool`s (`||`), `*` matches the AND on `bool`s (`&&`) and `undefined - var` matches the negation on `bool`s (`!`).

---

## Casting and checking variable types

Variables can be cast to other types by using the corresponding casting functions: `bool()`, `int()`, `long()`, `double()`, and `string()`. Some examples follow:

<div class="code" src="handling_simple_data_1.ol"></div>

A variable type can be checked at runtime by means of the `instanceof` operator, whose syntax is:

<div class="syntax" src="syntax_handling_simple_data_1.ol"></div>

`instanceof` operator can be used to check variable typing with both native types and custom ones (see type subsection in [Communication Ports](basics/communication_ports.html) section). Example:

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

A variable is undefined until a value is assigned to it. In this state it is set to `undefined` which is equivalent to `null`, `NULL` or `nil` in other programming languages.

For checking the definition of a variable the `is_defined` predicate should be used, e.g.:

<div class="code" src="handling_simple_data_8.ol"></div>

Sometimes it is useful to undefine a variable, i.e. to remove its value and make it undefined again. 
Undefining a variable is done by using the `undef` statement, as shown in the example below.

<div class="code" src="handling_simple_data_9.ol"></div>

The operators do behave like this:

- `undefined + var = var`
- `undefined - var = -var` (negation of numbers and booleans)
- `undefined * var = var`
- `undefined / var = 0`
- `undefined % var = var`

---

## Dynamic arrays

[Arrays](http://en.wikipedia.org/wiki/Array_data_structure) in Jolie are [dynamic](http://en.wikipedia.org/wiki/Dynamic_array) and can be accessed by using the `[]` operator, like in many other languages.

Example:

<div class="code" src="handling_simple_data_10.ol"></div>

A key point for understanding and programming services in Jolie is that, 

<div class="attention"><p>in JOLIE every variable is a dynamic array.</p></div>

Jolie handles dynamic array creation and packing. This makes dealing with complex data easier, although Jolie hides this mechanism when the programmer does not need it. Whenever an array index is not specified, the implicit index for that variable is set by default to 0 (zero), like shown in the example below.

<div class="code" src="handling_simple_data_11.ol"></div>

### Array size operator `#`

Since its dynamic-array orientation, one handy feature provided by Jolie is the array size operator `#`, which can be used as shown in the examples below.

<div class="code" src="handling_simple_data_12.ol"></div>

### Nested arrays

Jolie\'s type system does not permit directly nested arrays as known in other programming languages. This limitation may be compensated by the introduction of children nodes (explained in [Data Structures](basics/data_structures.html)).

Example: The two-dimensional array `a` may not be defined nor accessed by `a[i][j]`, but `a[i].b[j]` is possible.

<div class="panel panel-primary">
  <div class="panel-heading">
    <p class="panel-title">Notice</p>
  </div>
  <div class="panel-body">
    <p>Certain input formats as JSON allow directly nested arrays though, e.g. <code>[[1,2],[3,4]]</code>. For this reason Jolie\'s JSON parser automatically inserts a <code>_</code>-named children node for each array. If the JSON data was saved in the variable <code>matrix</code>, a single value may be obtained by <code>matrix._[i]._[j]</code>.</p>
    <p>The underscore trick works in both directions: by expressing nested arrays in this way, all <code>_</code>-named members again disappear on conversion (back) into JSON.</p>
  </div>
</div>
