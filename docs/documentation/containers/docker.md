Here we discuss how to use Jolie together with Docker.

## Quick start with pre-built image
This solution requires [Docker](http://www.docker.com) previously installed in your machine.

Open a shell and pull the most recent Jolie image with the command

<kbd>docker pull jolielang/jolie1.6.0beta1</kbd>

Once the image is available on your machine, create a container from it by adding a local volume where storing the Jolie files:

<kbd>docker run -it -v /your-host-folder-path:/your-container-path --name
CONTAINERNAME jolielang/jolie1.6.0beta1</kbd>

Now you can edit your files in folder `/your-host-folder-path` and find them in your container folder `/your-host-folder-path`.

Finally, to run a Jolie microservice type <kbd>jolie your_file.ol</kbd> in the launched shell.

Containers are also useful to test systems of microservices running within the same container. 
To run a new microservice on the same container type <kbd>docker exec -it CONTAINERNAME bash</kbd> to launch a new shell, 
following the previous commands to execute the desired service.

## Running examples in Jolie documentation with Docker
Many of the examples presented in this documentation can run with the Jolie Docker image, without the need to install Jolie directly in your OS.
The easiest way to run them is to directly pull the docker image `jolielang/jolie-examples` with command <kbd>docker pull jolielang/jolie-examples</kbd>

The folder `/examples` of the container includes all the complete examples reported in the documentation (see the related [repository](https://github.com/jolie/examples)).

## Run your Jolie microservices in a Docker image
This section explain how to build a deployable docker container which includes custom Jolie microservices. 
In order to do this, it is sufficient to develop the microservice by following some simple steps.

### 1) Specify on which image you are building FROM

To do this, create a file named `Dockerfile` in the working directory and write the following lines:

<pre>
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME <EMAIL>
</pre>

where SURNAME, NAME, and EMAIL must be replaced with the maintainer's surname, name, and email respectively.
The Dockerfile will be used by Docker to build the image related to the microservice.

Note that the image will be layered upon a previously created image called `jolielang/jolie-docker-deployer`, which can be found in the docker hub of `jolielang`.

<!-- Such a docker image is prepared to facilitate the deployment of a Jolie microservice as a docker image.
In order to use it in the right way, it is necessary to follow the next rules. -->

As an example, let us suppose to deploy the following microservice saved in file `helloservice.ol`:

<div class="code" src="docker_hello.ol"></div>
    
### 2) EXPOSE the inbound ports (inputPorts)

All the inputPorts of the microservice must EXPOSEd by the container. This is specified in the Dockerfile too.

<div class="doc_image">
  <img src="documentation/containers/img/container.png" />
  <p><b>Fig.1</b> Service hello example</p>
</div>

Note that in the previous example the inputPort is located at `localhost:8000`. 
To make the service reachable from the outside, we need to add `EXPOSE 8000` in the Dockerfile. 
Hence, the Dockerfile becomes:

```
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME <EMAIL>
EXPOSE 8000
```

### 3) COPY the files of your project
COPY the files of the project in the docker image. When doing this, pay attention to rename the file to be run with the name `main.ol`.

```
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME
EXPOSE 8000
COPY helloservice.ol main.ol
```

### 4) Build the image
With the Dockerfile ready, we can build the docker image of the microservice. To do this, run command <kbd>docker build -t hello</kbd> within the working directory that contains the Dockerfile.
Here, `hello` is the name we give to the image. Once finished, you can check the presence of the image in the local registry with command <kbd>docker images</kbd>.

### 5) Run the container
Once the image is built, we can run the container with command <kbd>docker run --name hello-cnt -p 8000:8000 hello</kbd> where `hello-cnt` is the name given to the container. 
Note that the parameter `-p` maps the microservice port (8000) to the port 8000 of the host (localhost). 

Once launched, it is possible to check that the container is running with command <kbd>docker ps</kbd> (the command lists all the running containers).

With our container running, the microservice is now deployed and it is listening for requests at port 8000. 
We can now invoke it with a client like the following one (remember to launch the client in a separate shell of the localhost).

<div class="code" src="client.ol"></div>

## Advanced settings
Usually we deal with microservices that are more complicated than the hello service presented before. 
In particular, it is very common to assign constants (e.g., the locations of outputPorts) at the time of the deployment. 

The following service illustrates this case.

<div class="code" src="docker_hello_plus.ol"></div>

The microservice above has a dependency on the previous one. Indeed, to implement `helloPlus`, it requires to invoke the operation `hello` of the previously deployed microservice. 
Moreover, it uses a constants `CUSTOM_MESSAGE` to define a string to be added to the response.

<div class="doc_image">
	<img src="documentation/containers/img/container2.png" />
	<p><b>Fig.2</b> Service hello plus example</p>
</div>

In general, constant values defined at deployment time are useful to deal with the architectural context where the microservice runs. Thus, it is important to create an image which is configurable when it is run as a container. This adds another step to the previous ones.

### 6) Prepare constants to be defined at deployment time
The image `jolielang/jolie-docker-deployer` has been built with some specific scripts executed before running the `main.ol`. These scripts read the environment variables passed to the docker container and store them in a file of constants read by your microservice.
The most important facts to know here are:

1. only the environment variables prefixed with `JDEP_` are be processed;
2. the processed environment variables are stored in a file of constants named `dependencies.iol`. If it exists it will be overwritten.

Hence, the microservice definition must be changed as it follows:

<div class="code" src="docker_hello_plus2.ol"></div>

In the example we use two constants `JDEP_HELLO_LOCATION` and `JDEP_CUSTOM_MESSAGE`. 
Hence, as specified at point 2., we include file `dependencies.iol` to retrieve them within our container.

To test the service locally (before including it in the container), add a `dependencies.iol` file in the working direction which contains the definition of the mentioned constants.

<div class="code" src="dependencies.iol"></div>

During the local development/testing use the file `dependencies.iol` to collect all the constants to be defined at deployment time. However, as already remarked, it is not necessary to copy it into the docker image (in any case, it would be overwritten).

Finally we include the new service `helloPlus` in our Dockerfile:

```
FROM jolielang/jolie-docker-deployer
EXPOSE 8001
MAINTAINER SURNAME NAME <EMAIL>
COPY helloservicePlus.ol main.ol
```

and we create a new image called `hello_plus` with command <kbd>docker build -t hello_plus</kbd>.

### 7) Configure the container
To run the `hello_plus` image we need to pass the value of the constants to the running container.
Docker allows to pass environment variables with the parameter `-e`.
For example, the command 
<kbd>docker run --name hello-plus-cnt -p 8001:8001 -e JDEP_HELLO_LOCATION="socket://172.17.0.4:8000" -e JDEP_CUSTOM_MESSAGE=" :plus!" hello_plus</kbd> 
launches the image `hello_plus` with constants `JDEP_HELLO_LOCATION` set to `"socket://172.17.0.4:8000"` and `JDEP_CUSTOM_MESSAGE` set to `" :plus!"`.

In particular `"socket://172.17.0.4:8000"` is the address Docker assigned to the container `hello-cnt` running service `hello.ol`, on which `hello_plus` depends (we can obtain the address of `hello-cnt` with the command <kbd>docker inspect --format '{{ .NetworkSettings.IPAddress }}' hello-cnt</kbd>).

Once `hello-plus-cnt` is running, it is possible to invoke it with the following client:

<div class="code" src="client2.ol"></div>

This example is also available in the jolie [example repo](https://github.com/jolie/examples/tree/master/06_containers/01_deployment_with_docker).