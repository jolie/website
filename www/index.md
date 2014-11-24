<!--Themed-->


<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-6">
      <img class="img-responsive" src="imgs/microservice-logo.png">
    </div>
    <div class="col-xs-6">
      <div><h1>The first language for Microservices</h1>
      </div>
    </div>
  </div>
</div>

## Native microservice programming

Jolie crystallises the programming concepts of microservices as native
language features: the basic building blocks of software are not objects or
functions, but rather services that can always be relocated and replicated as
needed. Distribution and reusability are achieved by design.

Jolie is a service-oriented language.

## Built for the networked age: distributable by design

Jolie code is always contained in services, which you can always move
from being local to remote and vice versa, without altering the logic of
your programs. A monolithical application can scale to being distributed
by design: if you decide to distribute a part of it, just take it and
execute it in another machine.

<div class="col-xs-6 text-center">
  ### Program your microservice system
  <img class="landing-img" src="imgs/basesystem.png">
</div>
<div class="col-xs-6 text-center">
  ### Deploy it in a single machine
  <img class="landing-img" src="imgs/monolithicaldeployment.png">
</div>
<div class="col-xs-6 text-center">
  ### Deploy it in two different machines
  <img class="landing-img" src="imgs/doubledeployment.png">
</div>
<div class="col-xs-6 text-center">
  ### Deploy it in four different machines
  <img class="landing-img" src="imgs/fourdeployment.png">
</div>
<div class="clearfix"></div>

## Protocol agnostic

Jolie is protocol agnostic: your services can exchange data by using
different protocols. Bridging two networks using different protocols is
a matter of a few lines of code! And if you need a protocol that Jolie
does not support yet, there is an API for easily developing new ones in
Java.

<div class="text-center">
  <img src="imgs/protocolindependence.png">
</div>

Everything you build can be used to build again
Jolie offers many ways for building complex software from simple
services. Even the deployment architecture of a system can be programmed
with native primitives, generalising common practices. Whatever you
build, is again a service that you can expose; so, it can be reused to
build again! Here are some examples of composition:

<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-8">**Orchestration:** an orchestrator is a service that offers functionalities obtained by coordinating other services with a workflow. </div> 
    <div class="col-xs-4">
      <img class="img-responsive" src="imgs/orchestration.png">
    </div> 
  </div>
</div>

<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-8">**Aggregation:** a generalisation of proxies and load balancers, which you can use to compose and expose the APIs of separate services.</div>
    <div class="col-xs-4">
      <img class="img-responsive" src="imgs/aggregation.png">
    </div>
  </div>
</div>

<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-8">**Redirection:** a generalisation of virtual servers, which hides the actual locations of services to clients by assigning logical names to services.</div>
    <div class="col-xs-4">
      <img class="img-responsive" src="imgs/redirection.png">
    </div>
  </div>
</div>

<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-8">**Embedding:** a generalisation of application servers, which runs other services as inner components. It enables fast local communications and can even run code written in different languages than Jolie, such as Java and Javascript (with more coming)!</div>
    <div class="col-xs-4">
      <img class="img-responsive" src="imgs/embedding.png">
    </div>
  </div>
</div>
<div class="clearfix"></div>

## Structured workflows

Jolie comes with native primitives for structuring workflows, for
example in sequences (one after the other) or parallels (go at the same
time). This makes the code follow naturally from the requirements,
avoiding error-prone bookkeeping variables for checking what happened so
far in a computation. For example, the following code says that the
operations `publish` and `edit` become available at the same time (`|`),
but only after (`;`) operation `login` is invoked:

<pre>
login( credentials )() { checkCredentials };
{ publish( x ) | edit( y ) }
</pre>

## Dynamic error handling for parallel code
Programming reliable parallel code is challenging because faults may
cause side-effects in parallel activities. Jolie comes with a solid
semantics for parallel fault handling. Programmers can update the
behaviour of fault handlers at runtime, following the execution of
activities thanks to the `install` primitive.

<pre>
include "console.iol"
include "time.iol"

main
{
    scope( grandFather )
    {
        install( this => 
            println@Console( "recovering grandFather" )()
        );
        scope( father )
        {
            install( this => 
                println@Console( "recovering father" )()
            );
            scope ( son )
            {
                install( this => 
                    println@Console( "recovering son" )()
                );
                sleep@Time( 500 )();
                println@Console( "Son's code block" )()
            }
        }
    }
    |
    throw( a_fault )
}
</pre>

## Revolutionise the way you develop web applications

**Jolie requires interfaces to be clearly defined**, thus web GUIs are
completely independent from the microservice system they interact with.
A Jolie service of a few lines of code, called Leonardo, acts as a web
server which can interoperate with web applications written in different
technologies. For example, we natively support JSON, XML, AJAX, GWT, and
other technologies. 

<div class="col-xs-offset-1 col-xs-10">
<img class="img-responsive" src="imgs/interface.png">
</div>
<div class="clearfix"></div>

## Solid foundations
<div class="container col-xs-12">
  <div class="row vertical-align">
<div class="col-xs-4"><img class="img-responsive" src="imgs/solid_foundations.png"></div>
<div class="col-xs-8">Jolie comes with formal specifications of its semantics. It is used in Computer Science research and teaching at many universities around the world. See the [Academy](?top_menu=academy "academy") page for more information about where you can study or work with Jolie.</div>
<div class="clearfix"></div>
</div>
</div>
   
## Join us!
<div class="container col-xs-12">
  <div class="row vertical-align">
<div class="col-xs-8">Jolie is an [open source project](about_jolie.html), with a growing community of contributors and users that you are welcome to [join](community.html). Check out our [project news](news.html), or have a look at our [contributor blogs](blogs.html).</div> 
<div class="col-xs-4"><img class="img-responsive" src="imgs/news.png"></div>
<div class="clearfix"></div>
</div>
</div>


## Start now to build your distributed system!
<div class="container col-xs-12">
  <div class="row vertical-align">
    <div class="col-xs-4">
      <img class="img-responsive" src="imgs/lego.png">
    </div>
    <div class="col-xs-8">
### You do not need frameworks, just an interpreter.
You do not need special frameworks for deploying
services, nor an ESB for achieving integration: you just need to install the
Jolie interpreter, write a few lines of code, and run them with a single
command:
    <kbd>jolie my_service.ol</kbd>
    </div>
  </div>
</div>
<div class="clearfix"></div>