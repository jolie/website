## Defining a Jolie application behaviour

The behaviour of a Jolie application is defined by conditions, loops, and statement execution rules.

Whilst conditions and loops implement the standard conditional and iteration constructs, execution rules defines the priority among code blocks. 

---

## Statement execution operators

Jolie offers three kinds of operators to compose statements in sequence, parallel, or as a set of input choices.

## Sequence

The sequence operator `;` denotes that the left operand of the statement is executed *before* the one on the right. The sequence operator syntax is:

<div class="syntax" src="syntax_composing_statements_workflow_1.ol"></div>

A valid use of the sequence operator is as it follows:

<div class="code" src="composing_statements_workflow_1.ol"></div>

<div class="panel panel-primary">
 	<div class="panel-heading">
  	<p class="panel-title">Attention</p>
  </div>
  <div class="panel-body">
    <p>Keep in mind that, in Jolie, <code>;</code> is NOT the "end of statement" marker.</p>
		For the sake of clarity, let us consider an INVALID use of the sequence operator:
		<div class="code" src="composing_statements_workflow_2.ol"></div>
	</div>
</div>

---

## Parallel

The parallel operator `|` states that both left and right operands are executed *concurrently*. The syntax of the parallel operator is:

<div class="syntax" src="syntax_composing_statements_workflow_2.ol"></div>

It is a good practice to explicitly group statements when mixing sequence and parallel operators. Statements can be grouped by enclosing them within an unlabelled [scope](fault_handling/basics.html) represented by a pair curly brackets `{}`, like in the following example:

<div class="code" src="composing_statements_workflow_7.ol"></div>

The parallel operator has always priority on the sequence one, thus the following code snippets are equivalent:

<div class="code" src="composing_statements_workflow_3.ol"></div>
<div class="code" src="composing_statements_workflow_4.ol"></div>

Parallel execution is especially useful when dealing with multiple services, in order to minimize waiting times by managing multiple communications at once.

In this example we concurrently retrieve information from both a forecast and a traffic service:

<div class="code" src="composing_statements_workflow_5.ol"></div>

<div class="download"><a href="documentation/basics/code/composing_statements_parallel.zip">Click here to download the comprehensive code of the example above.</a></div>

Concurrent access to shared variables can be restricted through [synchronized](basics/processes.html) blocks.

---

## Input choice

The input choice implements **input-guarded choice**. Namely, it supports the receiving of a message for any of the statements in the choice. When a message for an input statement `IS_i` can be received, then all the other branches are deactivated and `IS_i` is executed. Afterwards, the related branch behaviour `branch_code_1` is executed. A static check enforces all the input choices to have different operations, so to avoid ambiguity.

The syntax of an input choice is:

<div class="syntax" src="syntax_composing_statements_workflow_3.ol"></div>

Let us consider the example below in which only `buy` or `sell` operation can execute, while the other is discarded.

<div class="code" src="composing_statements_workflow_6.ol"></div>

---

## Conditions and conditional operator

Conditions are used in control flow statements in order to check a boolean expression. Conditions can use the following relational operators:

- `==`: is equal to;
- `!=`: is not equal to;
- `<`: is lower than;
- `<=`: is lower than or equal to;
- `>`: is higher than;
- `>=`: is higher than or equal to;
- `!`: negation

Conditions can be used as expressions and their evaluation always returns a boolean value (true or false). That value is the argument of conditional operators.

Some valid conditions are:

<div class="code" src="composing_statements_controlflow_5.ol"></div>

The statement `if ... else` is used to write deterministic choices:

<div class="syntax" src="syntax_composing_statements_controlflow_1.ol"></div>

Note that the `else` block is optional (denoted by its enclosure in square brackets).

Like in many other languages, the `if ... else` statement can be nested and combined:

<div class="code" src="composing_statements_controlflow_4.ol"></div>

---

## for and while

The `while` statement executes a code block as long as its condition is true.

<div class="syntax" src="syntax_composing_statements_controlflow_3.ol"></div>

Like the `while` statement, `for` executes a code block as long as its condition is true, but it explicitly defines its initialization code and the post-cycle code block, which is executed after each iteration.

<div class="syntax" src="syntax_composing_statements_controlflow_2.ol"></div>

Example:

<div class="code" src="composing_statements_controlflow_1.ol"></div>
