## Internal Services

Jolie gives a limited support to procedural programming. With the [define](#!documentation/basics/define.html) keyword it is possible to define callable blocks of code, but it is not possible to pass local variables. This is an intentional choice as using procedures too much can hinder switching to a distributed implementation based on communications later on.

In essence, a procedure acts as a request-response invocation. The main workflow calls it and then waits until the latter returns its result. Based on this design, one service can implement recursive algorithms by calling itself on one of its operations. 

This design pattern does not follow a (micro)service paradigm as algorithms should be implemented in a separate service. However, it is also true that creating separate services can be cumbersome sometimes, e.g., during prototyping. 

Internal services address this problem. With internal services, on one hand the programmer does not have to code a fully-fledged Jolie service on separate files, embed them, and set all references to ports and interfaces. On the other hand they inhibit the use of bad design patterns e.g., self-calls.

Moreover, later on it is very easy to extract the code of an internal service and make it a standalone Jolie service.

The syntax for internal services is

<div class="syntax" src="syntax_internal_services_1.ol"></div>

The internal service construct specifies:

- a name `SrvName` for the service. The name will act as OutputPort for the owner of the internal service to call it;
- the `Interfaces` of the service (it is possible to declare interfaces fetched in included files, just as regular services).
- an optional `init`ialisation procedure, as for regular services;
- a `main` procedure, as for regular services;

The internal service has access to all the output ports defined in the owner. This is limited to the information statically defined therein, not the dynamic binding set by the owner.

<div class="panel panel-primary">
 	<div class="panel-heading">
  	<p class="panel-title">Attention</hp>
  </div>
  <div class="panel-body">
    <p>The internal service has set <code>execution { concurrent }</code> by default. </p>
    <p>
    	This is convenient, although it contrasts with the usual execution for normal Jolie services, which is set to <a href="!documentation/basics/composing_statements.html#statement-execution-operators">single</a> by default. No way of changing the execution modality is provided for internal services.
    </p>
	</div>
</div>

Finally, internal services are just syntactic sugar for embedded Jolie service, i.e., what happens at runtime is that the owner of the internal services loads them as embedded services which will behave as such, with the consequent access through Runtime and all the usual features.