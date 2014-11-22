## Jolie data structures

Jolie data structures are tree-like. It is easier to understand them by making a comparison between a data structure in Jolie and its equivalent in XML.

## Creating a data structure

Let us create a root node, named `animals` which contains two children nodes: `pet` and `wild`. Each of them is an array with two elements, respectively equipped with another sub-element (its name).

<div class="code" src="data_structures_1.ol"></div>

Equivalent representations of the structure of `animals` in XML and JSON are, respectively:

<div style="overflow:auto"><div style="width:49%; float:left;"><div class="code" src="data_structures_1.xml"></div></div><div style="width:49%; float:left;"><div class="code" src="data_structures_1.json"></div></div></div>

---

## Navigating data structures

Data structures are navigated using the `.` operator, which is the same used for creating nested structures. The structures created by nesting variables are called *variable paths*. Some examples of valid variable paths follows:

<div class="code" src="data_structures_2.ol"></div>

`.` operator requires a single value operand on its left. Thus if no index is specified, it is defaulted to 0. In our example the variable path at Line 5 is automatically translated to:

<div class="code" src="data_structures_3.ol"></div>

---

## Dynamic look-up

Nested variables can be identified by means of a string expression evaluated at runtime.

Dynamic look-up can be obtained by placing a string between round parentheses. Let us consider the `animals` structure mentioned above and write the following instruction:

<div class="code" src="data_structures_4.ol"></div>

The string `"pet"` is evaluated as an element's name, nested inside `animals` structure, while the rest of the variable path points to the variable `name` corresponding to `pet`'s first element. Thus the output will be `cat`.

Also a concatenation of strings can be used as an argument of a dynamic look-up statement, like in the following example, which returns the same result as the previous one.

<div class="code" src="data_structures_5.ol"></div>

---

## `foreach` - traversing items 

Data structures can be navigated by exploiting the `foreach` statement, whose syntax is:

<div class="syntax" src="syntax_data_structures_1.ol"></div>

`foreach` operator looks for any child-node name inside `root` and puts it inside `nameVar`, executing the internal code block at each iteration. 

Combining `foreach` and dynamic look-up is very useful for navigating and handling nested structures:

<div class="code" src="data_structures_6.ol"></div>

In the example above `kind` ranges over all child-nodes of `animals` (`pet` and `wild`), while the `for` statement ranges over the elements of the current `animals.kind` node, printing both it's path in the structure and its content:

<div class="code" src="data_structures_6_out.ol"></div>

---

## `with` - a shortcut to repetitive variable paths

`with` operator provides a shortcut for repetitive variable paths.

In the following example the same structure used in previous examples (`animals`) is created, avoiding the need to write redundant code:

<div class="code" src="data_structures_7.ol"></div>

---

## `undef` - erasing tree structures

A structure can be completely erased - undefined - using the statement `undef`:

<div class="code" src="data_structures_9.ol"></div>

---

## `<<` - copying an entire tree structure

The deep copy operator `<<` copies an entire tree structure into another.

<div class="code" src="data_structures_8.ol"></div>

In the example above the structure `animals` is completely copied in structure `sector_a`, which is a nested element of the structure `zoo`. Therefore, even if `animals` is undefined at Line 2, the structure `zoo` contains its copy inside `section_a`. 

For the sake of clarity a representation of the `zoo` structure is provided as it follows:

<div class="code" src="data_structures_8.xml"></div>

---


## `->` - structures aliases

A structure element can be an alias, i.e. it can point to another variable path.

Aliases are created with the `->` operator, like in the following example:

<div class="code" src="data_structures_10.ol"></div>

<div class="attention"><p>Aliases are evaluated every time they are used.</p></div>

Thus we can exploit aliases to make our code more readable even when handling deeply nested structure like the one in the example below:

<div class="code" src="data_structures_11.ol"></div>

The alias `currentElement[ 0 ]` is used to refer to the `i`-th element of `d` nested inside `a.b.c`. At each iteration the alias is evaluated, using the current value of `i` variable as index. Therefore, the example's output is:

<div class="code" src="data_structures_11_out.ol"></div>