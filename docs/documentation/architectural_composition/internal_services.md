## Internal Services

<div class="panel panel-primary">
 	<div class="panel-heading">
  	<p class="panel-title">Attention</hp>
  </div>
  <div class="panel-body">
    <p>Internal services are <strong>due to release</strong>. They will be available since the next release of Jolie.
    </p>
	</div>
</div>

Internal Services are embedded Jolie services defined directly within the embedder program, rather than in a separate file. They offer a convenient way of reusing code as in procedural programming, without breaking the principle that such code should be easily exported to an external microservice. In particular, an internal service can always be easily moved to a separate file to make it a standalone service, without requiring code changes in the behaviours of the other services that were interacting with it. This is in contrast with the [define](#!documentation/basics/define.html) keyword, which is intended only for short configuration macros or recursive workflows.

Beside the ease of refactoring (e.g., moving the service from internal to standalone), internal services offer another main advantage: fast prototyping. The programmer does not have to code a fully-fledged Jolie service in a separate file, embed it, and set the appropriate communication ports. Internal services are no more than syntactic sugar, but this automation saves a lot of boilerplate coding to the developer.

The syntax for internal services is

<div class="syntax" src="syntax_internal_services_1.ol"></div>

The `service` construct specifies:

- a name `SrvName` for the service. The name will act as an output port for the owner of the internal service to call it;
- the `Interfaces` of the service (it is possible to declare interfaces fetched in included files, just as regular services).
- an optional `init`ialisation procedure, as for regular services;
- a `main` procedure, as for regular services;

The internal service has access to all the output ports defined in the owner. This is limited to the information statically defined therein, not the dynamic bindings set by the caller processes.

<div class="panel panel-primary">
 	<div class="panel-heading">
  	<p class="panel-title">Attention</hp>
  </div>
  <div class="panel-body">
    <p>Every internal service has <code>execution { concurrent }</code> set by default. </p>
    <p>
    	This is convenient, although it contrasts with the usual execution for normal Jolie services, which is set to <a href="!documentation/basics/composing_statements.html#statement-execution-operators">single</a> by default.
    </p>
	</div>
</div>

Semantically, internal services are just syntactic sugar for embedded Jolie service, i.e., what happens at runtime is that the owner of the internal services loads them as embedded services, with the consequent access through the `Runtime` standard service and all the usual features.

## Tree as a Service

Let us see an example of Internal Services in action with a simplified implementation of the `tree` command in Jolie. In Unix and Unix-like systems, `tree` is a recursive directory listing program that produces a depth-indented listing of files.

With internal services its is very quick and easy to draft a prototype implementation of tree

<div class="code" src="internal_services_1.ol"></div>