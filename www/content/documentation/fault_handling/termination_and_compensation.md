## Termination and compensation

*Termination* and *compensation* are mechanisms which deal with the recovery of activities.

Termination deals with the recovery of an activity that is still running.

Compensation deals with the recovery of an activity that has successfully completed its execution.

Each scope can be equipped with an error handler that contains the code to be executed for its recovery. As for fault handlers, recovery handlers can be dynamically installed by means of the `install` statement. Besides using a specific fault name, which installs the handler as a *fault handler*, the handler can refer to `this` or `default` keywords.

In case the handler refers to `this`, it is a *termination* or *recovery handler* for the enclosing scope, if it refers to `default`, the handler is installed as a *fallback fault* handler for all faults that do not have a specific fault handler.

Installing a handler overwrites the previous one for the same fault or scope name; however, handlers can be composed by using the `cH` placeholder, which is replaced by the code of the previously installed handler.

---

## Termination

Termination is a mechanism used to recover from errors: it is automatically triggered when a scope is unexpectedly terminated from a parallel behaviour and must be smoothly stopped.

Termination is triggered when a sibling activity raises a fault. Let us consider the following example:

<div class="code" src="termination_and_compensation_1.ol"></div>

In the example above, the code at Lines 7 and 13 is executed concurrently. In `scope_name`, a recovery handler is initially installed and then the code at Line 10 is executed. Besides, the parallel activity may raise the fault at line 13. In that case a termination is triggered and the corresponding recovery code is executed.

### Terminating child scopes

When termination is triggered on a scope, the latter recursively terminates its own child scopes. Once all child scopes terminated, the recovery handler is executed. Let us consider the following example:

<div class="code" src="termination_and_compensation_2.ol"></div>

If the fault is raised when the scope `son` is still executing (we use Jolie's standard library `time` for making the child process wait for 500 milliseconds), a termination is triggered for scope `grandFather`, which triggers the termination of scope `father`. Finally, scope `father` triggers the termination of the scope `son`, which executes its own recovery handler. Inside-out, `son`'s, `father`'s and `grandFather`'s recovery handlers are executed subsequently.

### Dynamic installation of recovery handlers

Recovery handlers can be dynamically updated like fault handlers. Example:

<div class="code" src="termination_and_compensation_3.ol"></div>

When `a_fault` is raised, the lastly installed recovery handler is executed.

---

## Handler composition - the `cH` placeholder

Besides replacing a recovery handlers, it may be useful to add code to the current handler, without replacing the entire previously installed code. Jolie provides the keyword `cH` as a placeholder for the *current handler*.

Let us consider the following example:

<div class="code" src="termination_and_compensation_4.ol"></div>

`cH` can be composed within another handler by means of the sequence and parallel operators. The resulting handler will be the composition of the previous one (represented by `cH`) and the new one.

---

## Compensation

Compensation allows to handle the recovery of a scope which has successfully executed. When a scope finishes with success its own activities, its current recovery handler is promoted to the parent scope in order to be available for compensation.

Compensation is invoked by means of the `comp` statement, which can be used only within a handler.

Let us consider the following example showing how to perform a compensation:

<div class="code" src="termination_and_compensation_5.ol"></div>

When scope `example_scope` ends with success, its current recovery handler is promoted to the parent scope (`main`) in order to be available for compensation. At the end of the program, the `a_fault` is raised, triggering the execution of its fault handler, defined at Lines 5-8. At Line 7 the compensation of scope `example_scope` is executed, triggering the execution of the corresponding recovery handler (in this case, the one at Line 15, including the first at Line 11).

---

## Installation-time variable evaluation

Handlers need to use and manipulate variable data often and a handler may need to refer to the status of a variable at the moment of its installation. Hence, Jolie provides the `^` operator which "freezes" a variable state within an installed handler. `^` is applied to a variable by prefixing it, as shown in the example below.

<div class="code" src="termination_and_compensation_6.ol"></div>

The install primitive contained in the `while` loop updates the scope recovery handler at each iteration. In the process the value of the variable `i` is frozen within the handler.