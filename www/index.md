<!--Themed-->

<div id="home_section_1" class="home_section_inside">
	<table align="center">
		<td><img src="imgs/microservice-logo.png"></td>
		<td><div id="site-title">The first language for Microservices</div></td>
	</table>
</div>

<div id="home_section_2" class="home_section home_section_even">
	<div class="scroll_home" onclick="scroll_home('home_section_3')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Native microservice programming</div>
	<div class="home_section_text">
	Jolie cristallises the programming concepts of microservices as native language features:
	the basic building blocks of software are not objects or functions, but rather
	services that can always be relocated and replicated as needed.
	Distribution and reusability are achieved by design.
	<div class='highlight'>Jolie is a service-oriented language.</div>
	</div>
	</div>
</div>

<div id="home_section_3" class="home_section home_section_odd">
	<div class="scroll_home" onclick="scroll_home('home_section_4')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Built for the networked age: distributable by design</div>
	<div class="home_section_text">
	Jolie code is always contained in services, which you can always move from being local to remote and vice 
versa, without altering the logic of your programs.
	A monolithical application can scale to being distributed by design:
	if you decide to distribute a part of it, just take it and execute it in another machine.<br/>
	<table>
	    <tr><td>Program your microservice system<br/><br/><img src='imgs/simplesystem.png'></td><td>Deploy it in 
a single machine<br/><img src='imgs/monolithicaldeployment.png'></td></tr>
	    <tr><td>Deploy it in two<br/>different machines<br/><img src='imgs/doubledeployment.png'></td><td>Deploy it 
in<br/>four different machines<br/><img src='imgs/fourdeployment.png'></td></tr>
	</table>
	</div>
	</div>
</div>

<div id="home_section_4" class="home_section home_section_even">
	<div class="scroll_home" onclick="scroll_home('home_section_5')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Protocol agnostic</div>
	<div class="home_section_text">
	Jolie is protocol agnostic: your services can exchange data by using different protocols.
	Bridging two networks using different protocols is a matter of a few lines of code!
	And if you need a protocol that Jolie does not support yet, there is an API for easily developing
	new ones in Java.
	<div class="home_section_image"><img src='imgs/protocolindependence.png'></div>
	</div>
	</div>
</div>


<div id="home_section_5" class="home_section home_section_odd">
	<div class="scroll_home" onclick="scroll_home('home_section_6')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Everything you build can be used to build again</div>
	<div class="home_section_text">
	Jolie offers many ways for building complex software from simple services.
	Even the deployment architecture of a system can be programmed with native
	primitives, generalising common practices.
	Whatever you build, is again a service that you can expose; so,
	it can be reused to build again!
	Here are some examples of composition:
	<table>
	    <tr>
	    <td vertical-align="middle">
	    <b>Orchestration:</b>
	    an orchestrator is a service that offers functionalities obtained by coordinating other 
	    services with a workflow.
	    </td><td>
	    <img src="imgs/orchestration.png">
	    </td>
	    </tr>
	    <tr>
	    <td vertical-align="middle">
	    <b>Aggregation:</b> a generalisation of proxies and load balancers, which you can use to compose and 
 expose the APIs of separate services.
	    </td><td>
	    <img src="imgs/aggregation.png">
	    </td>
	    </tr>
	    <tr>
	    <td vertical-align="middle">
	    <b>Redirection:</b> a generalisation of virtual servers, which hides the actual locations of services
	    to clients by assigning logical names to services.
	    </td><td>
	    <img src="imgs/redirection.png">
	    </td><td>
	    
	    </td>
	    </tr>
	    <tr>
	    <td vertical-align="middle">
	    <b>Embedding:</b> a generalisation of application servers, which runs other services as inner 
components. It enables fast local communications and can even run code written in different languages than Jolie, such
as Java and Javascript (with more coming)!
	    </td><td>
	    <img src="imgs/embedding.png"/>
	    </td><td>
	    
	    </td>
	    </tr>
	</table>
	</div>
	</div>
	
</div>

<div id="home_section_6" class="home_section home_section_even">
      <div class="scroll_home" onclick="scroll_home('home_section_7')">Next</div>
	<div class="home_section_inside">
	      <div class="home_section_title">Structured workflows</div>
	      <div class="home_section_text">
	      Jolie comes with native primitives for structuring workflows, for
      example in sequences (one after the other) or parallels (go at the
      same time).
      This makes the code follow naturally from the requirements, avoiding
      error-prone bookkeeping variables for checking what happened so far in a
      computation.
      For example, the following code says that the operations
      <code>publish</code> and <code>edit</code> become available at the
      same time (<code>|</code>), but only after (<code>;</code>) operation
      <code>login</code> is invoked:
		      <div class="home_section_code">
			      <div class="code" src="../../home/code/workflow.ol"></div>
		      </div>
	      </div>
	      <br/>
	      <div class="home_section_title">Dynamic error handling for parallel code</div>
	      <div class="home_section_text">
	      Programming reliable parallel code is challenging because faults may cause
	      side-effects in parallel activities.
	      Jolie comes with a solid semantics for parallel fault handling.
	      Programmers can update the behaviour of fault handlers at runtime, following the execution of activities 
thanks to the <code>install</code> primitive.
		<div class="home_section_code">
			<div class="code" src="../../home/code/errors.ol"></div>
		</div>
	      </div>
	</div>
	
</div>

<div id="home_section_7" class="home_section home_section_odd">
	<div class="scroll_home" onclick="scroll_home('home_section_8')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Revolutionize the way you develop web applications</div>
	<div class="home_section_text">
	<b>Jolie requires
	interfaces to be clearly defined</b>, thus web GUIs are completely independent from the microservice
	system they interact with. A Jolie service of a few lines of code, called Leonardo, acts as a web server 
which can interoperate with web applications written in different technologies. For example, we natively support
JSON, XML, AJAX, GWT, and other technologies.
	 <img style="width:960px;" src="imgs/interface.png"/>
	</div>
	</div>	
</div>



<div id="home_section_8" class="home_section home_section_even">
	<div class="scroll_home" onclick="scroll_home('home_section_9')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Solid foundations</div>
	<div class="home_section_text">
	<table>
	  <tr>
	      <td>
		    <img align="right" src="imgs/solid_foundations.png">
	      </td>
	      <td>
	      Jolie comes with formal specifications of its semantics.
	      It is used in Computer Science research and teaching at many universities
	      around the world.
		    See the <a 
						href="?top_menu=academy"
						onClick="top_menu('?top_menu=academy');return false;" 
						ref="academy" 
						title="academy" 
						src="academy/academy.html">
						Academy</a> page for more information about where you can study
		    or work with Jolie.
	      </td>
	  </tr>
	 </table>	
	</div>
	</div>
	
</div>


<div id="home_section_9" class="home_section home_section_odd">
	<div class="scroll_home" onclick="scroll_home('home_section_10')">Next</div>
	<div class="home_section_inside">
	<div class="home_section_title">Join us!</div>
	<div class="home_section_text">
	<table>
	  <tr>
	      <td>
		    <img align="right" src="imgs/news.png" />
	      </td>
	      <td>
		    Jolie is an
		    <a 
						href="?top_menu=about_jolie"
						onClick="top_menu('?top_menu=about_jolie');return false;" 
						ref="about_jolie" 
						title="about_jolie" 
						src="about_jolie/about_jolie.html">
						open source project</a>, with
			a growing community of contributors and users that you are welcome to
			<a 
						href="?top_menu=community"
						onClick="top_menu('?top_menu=community');return false;" 
						ref="community" 
						title="community" 
						src="community/community.html">
						join</a>.
		    Check out our
		    <a 
						href="?top_menu=news"
						onClick="top_menu('?top_menu=news');return false;" 
						ref="news" 
						title="news" 
						src="news/news.html">
						project news</a>,
			or have a look at our
			<a 
						href="?top_menu=blogs"
						onClick="top_menu('?top_menu=blogs');return false;" 
						ref="blogs" 
						title="blogs" 
						src="blogs/blogs.html">
						contributor blogs</a>.
	      </td>
	  </tr>
	 </table>	
	</div>
	</div>
	
</div>

<div id="home_section_10" class="home_section home_section_even">
	<div class="home_section_inside">
	<div class="home_section_title">Start now to build your distributed system!<br/>You do not need frameworks, just an 
interpreter.</div>
	<div class="home_section_text">
	<table>
	  <tr>
	      <td>
		    <img src="imgs/lego.png">
	      </td>
	      <td>
		    You do not need special frameworks for deploying services, nor an ESB for achieving integration:
		    you just need to install the Jolie interpreter, write a few lines of code, and run them with
		    a single command:
		    <div class="home_section_code">
			  <div class="code" src="run.ol"></div>
		    </div>
	      </td>
	  </tr>
	 </table>
	</div>
	</div>
</div>