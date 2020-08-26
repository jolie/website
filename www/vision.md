<!--Themed-->

The rise of computer networks is pushing for an evolution of computing, where the software and IT functionalities accessed by consumers are implemented as systems of inter-connected components that collaborate with each other. These components, called <strong>services</strong>, are deployed on infrastructures like the cloud, which enable developers to abstract considerably from the details of hardware support (like which computer is running which component).

From the point of view of developers and consumers, modern IT infrastructure is starting to look like a sea of services (depicted below).

<p class="text-center"><img src="imgs/coordmachine.png"></p>

<p class="vision-quote">&laquo;Modern IT infrastructure is starting to look like a sea of services&raquo;</p>

Services coordinate and use each other by means of exchanging messages over the network, requiring developers to think about aspects such as, but not limited to, data models, APIs, marshalling, and workflows.

Services deployed on the cloud can be reached from or reach out to clients and other services by means of communications.
<!-- So coordination services coordinate with each other by message passing. -->


# Further reading


Here we list two main articles from [DZone](https://dzone.com/) where we illustrate our idea for the future of software development in the cloud.

# From a computation machine to a coordination machine
_Containerization and cloud computing are leading us to a new way we are conceiving computational resources_ 

Historically, computer machines were developed for automatizing computation. Starting from abacus to modern computers, the main idea behind computer machines was to increase the power of human brain computation with an external device. Computation machines were theoretically modeled by Alan Turing using his Turing machine and their basic architecture was proposed by Von Neumann.

[_Read more..._](https://dzone.com/articles/the-new-computer-machine)

<div class="col-xs-12 text-center">
<img src="imgs/coordmachine.png">
</div>

# The red pill of (micro)services
_Why we need new programming languages for dealing with the new coordination machine?_ 

The reason is very simple and intuitive: usual programming languages like C, Java, Python, etc, were developed for facilitating computation programming, not coordination programming. In these languages indeed, communication and coordination are always achieved by exploiting specific libraries or external frameworks, they are not crystallized within the linguistic structure of the programming language. 

[_Read more..._](https://dzone.com/articles/the-red-pill-of-microservices)

<div class="col-xs-12 text-center">
<img src="imgs/morpheus.png">
</div>


