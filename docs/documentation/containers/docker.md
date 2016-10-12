Here we discuss how to use Jolie together with Docker.

## Quick start with pre-built image
This solution requires [Docker](http://www.docker.com) previously installed in
your machine.

Open a shell and pull the most recent Jolie image with the command

```
docker pull jolielang/jolie1.6.0beta1
```

Once the image is available on your machine, create
a container from it by adding a local volume where storing the Jolie files:

```docker run -it -v /your-host-folder-path:/your-container-path --name
CONTAINERNAME jolielang/jolie1.6.0beta1
```

Now you can edit your files in folder
`/your-host-folder-path` and find them in your container folder
`/your-host-folder-path`.

Finally, to run a Jolie microservice type `jolie your_file.ol` in the
launched shell.

Containers are also useful to test systems of microservices running within the
same container. To run a new microservice on the same container type
<kbd>docker exec -it CONTAINERNAME bash</kbd> to launch a new shell, following
the previous commands to execute the desired service.

### Running examples in Jolie documentation with Docker
The [Jolie documentation](http://docs.jolie-lang.org/) contains many running examples. With the Jolie Docker image you can run any of these examples without having Jolie directly installed in you OS.

The easiest way to run them is to directly pull the docker image `jolielang/jolie-examples` with command
```
docker pull jolielang/jolie-examples
```

The folder `/examples` of the container includes all the complete examples reported in the documentation (see the related [repository](https://github.com/jolie/examples)).

## Fast deployment of a Jolie microservice in a Docker container
This section deals with the possibility to build a deployable docker container which includes a developed Jolie microservice. In order to do this, it is sufficient to develop the microservice by following some simple rules:

###Rule 1 : create a Dockerfile for building an image of your microservice
Create a file named `Dockerfile` in the working directory and write the following lines:

```
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME <EMAIL>
```
where SURNAME, NAME and EMAIL must be replaced with the maintainer's surname, name and email respectively.
The Dockerfile will be used by Docker for building the image related to the microservice.
It is worth noting that the image will be layered upon a previously created image called `jolielang/jolie-docker-deployer` which can be found in the docker hub of jolielang.
Such a docker image, is prepared for facilitating the deployment of a jolie microservice as a docker image.
In order to use it in the right way, it is necessary to follow the next rules.

As an example, let us suppose to deploy the following microservice saved in file `helloservice.ol`:

<div class="code" src="docker_hello.ol"></div>

### Rule 2 : EXPOSE inputPorts ports
Here we remind that all the inputPorts of the microservice to be deployed must be reached from outside the container, thus it is necessary to expose them in the Dockerfile.

<div class="doc_image">
	<img src="documentation/containers/img/container.png" />
	<p><b>Fig.1</b> Service hello example</p>
</div>

In the example the inputPort is located at `localhost:8000`, thus it is required to add `EXPOSE 8000` in the Dockerfile. The Dockerfile now becomes like this:

```
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME <EMAIL>
EXPOSE 8000
```

### Rule 3 : COPY the files of the project and define the main.ol
Now it is necessary to copy the files of the project in the docker image. When doing this, pay attention to rename the file to be run with the name `main.ol`.

```
FROM jolielang/jolie-docker-deployer
MAINTAINER SURNAME NAME
EXPOSE 8000
COPY helloservice.ol main.ol
```

### Building the image
When the Dockerfile is ready it is possible to build the docker image of the microservice. In order to do this it is sufficient to run the following command within the working directory which also contains the Dockerfile.

```
docker build -t hello .
```

where `hello` is the name we give to the image. Once finished, it is possible to check the presence of the image in the local registry by running the following command:

```
docker images
```

### Running a container
Now, starting from the image, it is possible to run all the needed containers. A container can be run by launching the following command:

```
docker run --name hello-cnt -p 8000:8000 hello
```

where `hello-cnt` is the name here given to the container. Note that the parameter `-p` allows to map the microservice port (8000) to the port 8000 of the localhost. It is possible to check that the container is running just launching the following command which lists all the running containers:

```
docker ps
```

The microservice is now deployed and it is listening for requests at port 8000. It is possible to try to invoke it with a client like the following one. Warning: Remember to launch the client in a separate shell of the localhost!

<div class="code" src="client.ol"></div>

### Advanced settings
Usually we deal with microservices that are more complicated than the hello service presented before. In particular, it is very common the case where some constants or outputPort locations must be defined at deploying time. In order to show this point, let us now consider the following service:

<div class="code" src="docker_hello_plus.ol"></div>

This is a very simple microservice which has a dependency on the previous one. Indeed, in order to implement its operation `helloPlus`, it requires to invoke the operation hello of the previously deployed microservice. Moreover, it uses a constants `CUSTOM_MESSAGE` for defining a string to be added to the response string.

<div class="doc_image">
	<img src="documentation/containers/img/container2.png" />
	<p><b>Fig.2</b> Service hello plus example</p>
</div>

Usually, some of these parameters can be defined at deploying time because they directly deal with the architectural context where the microservice will run. Thus, it is important to create an image which is configurable when it is run as a container.

### Rule 4 : Prepare constants to be defined at deploying time
The pre-prepared image `jolielang/jolie-docker-deployer` for deploying microservice has been built with some specific scripts which are executed before running the `main.ol`. These scripts just read the environment variables passed to the docker container and transform them in a file of constants which must be read by your microservice. The most important facts to know here are:

- Only the environment variables prefixed with `JDEP_` will be processed
- The processed environment variables will be collected in a file of constants named `dependencies.iol`. If it exists it will be overwritten.

From these two points the microservice definition must be changed as it follows:

<div class="code" src="docker_hello_plus2.ol"></div>

It is worth noting that there are two constants `JDEP_HELLO_LOCATION` and `JDEP_CUSTOM_MESSAGE` which require to be defined at the start of the microservice. In particular, they must be defined in the file `dependencies.iol` which MUST BE included in the microservice definition. This file just contains the declaration of the two constants.

<div class="code" src="dependencies.iol"></div>

During the development keep this file in the project and collect here all the constants to be defined at deploying time. When the service will be run in the container this file will be overwritten thus, it is not necessary to copy it into the docker image.

The Dockerfile of the helloPlus service is very similar to the previous one:

```
FROM jolielang/jolie-docker-deployer
EXPOSE 8001
MAINTAINER SURNAME NAME <EMAIL>
COPY helloservicePlus.ol main.ol
```

It is possible to create the image with the same command used before, but where the name is `hello-plus`.

```
docker build -t hello_plus .
```

### Configuring the container
Now, it is important to know how to pass the constants to the running container.
Docker allows to pass environment variables with the parameter `-e` available for command run. The final command is:

```
docker run --name hello-plus-cnt -p 8001:8001 -e JDEP_HELLO_LOCATION="socket://172.17.0.4:8000" -e JDEP_CUSTOM_MESSAGE=" :plus!" hello_plus
```

where `hello-plus-cnt` is the name here we give to the container. Note that the constant JDEP_HELLO_LOCATION is set to  `"socket://172.17.0.4:8000"` where the IP is set to 172.17.0.4. It is just an example, here it is necessary to specify the IP that Docker assigned to the container `hello-cnt` which is executing the service `hello.ol`. It is possible to retrieve it just launching the following command

```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' hello-cnt
```

Once the `hello-plus-cnt` container is running, it si possible to invoke it with the following client:

<div class="code" src="client2.ol"></div>

This example is also available in the jolie [example repo](https://github.com/jolie/examples/tree/master/06_containers/01_deployment_with_docker).
