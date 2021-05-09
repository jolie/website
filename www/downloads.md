<!--Themed-->

<div>

<!-- Navigation tabs -->
<ul class="nav nav-tabs" role="tablist">
<li role="presentation" class="active"><a href="#installer" aria-controls="installer" role="tab" data-toggle="tab">Installer</a></li>
<li role="presentation"><a href="#package-managers" aria-controls="package-managers" role="tab" data-toggle="tab">Package Managers</a></li>
<li role="presentation"><a href="#compile" aria-controls="compile" role="tab" data-toggle="tab">Compile from Sources</a></li>
<li role="presentation"><a href="#docker" aria-controls="docker" role="tab" data-toggle="tab">Docker</a></li>
<li role="presentation"><a href="#editors" aria-controls="editors" role="tab" data-toggle="tab">Editors & Plug-ins</a></li>
</ul>

<!-- Tab panels -->
<div class="tab-content">
<div role="tabpanel" class="tab-pane active" id="installer">

## Jolie Binaries Installer

Jolie requires Java to run.

Make sure to have [Java](http://www.java.com/) 8 or
later installed before proceeding.
(If you have to use a previous version of Java, Jolie version 1.5.0 or previous requires only Java 6. See our <a href="https://github.com/jolie/website/tree/master/www/files/releases">previous releases</a>.)

### Get the Jolie installer

Download the Java-based installer of the latest release of Jolie:

<div class="col-xs-12 text-center">
<a href="https://github.com/jolie/jolie/releases/download/v1.10.1/jolie-1.10.1.jar">
<p class="download">Jolie Installer (Stable: 1.10.1)</p>
</a>
</div>
<!-- <div class="col-xs-6 text-center">
<a href="https://github.com/jolie/jolie/releases/download/v1.10.1-beta3/jolie-1.10.1-beta3.jar">
<p class="download">Jolie Installer (Preview: 1.10.1-beta3)</p>
</a>
</div> -->

Here you can find the <a href="https://github.com/jolie/jolie/releases">previous releases</a> of Jolie.

### Run the Jolie installer

Open a shell terminal, access the directory in which you downloaded the
installer, and execute <kbd>java -jar jolie-1.10.1.jar</kbd>. The installer may
need permissions to write in the directories in which you intend to install
Jolie. Depending on your Operating System you can launch the Jolie installer
with elevated privileges:

<ul>

<li><strong>on Windows</strong>, by start a command prompt with <a
  href="https://technet.microsoft.com/en-us/library/cc947813.aspx">
  administrator privileges</a> and launch the installer;</li>

<li><strong>on Linux/MacOS</strong>, by launching the installer as root with command
<kbd>sudo java -jar jolie-1.10.1.jar</kbd>.</li>

</ul>

Please, check that the two environment variables below are correctly set to run Jolie:

- `PATH`: must include the installation path of the Jolie launchers;
- `JOLIE_HOME`: must point to the installation folder of the Jolie binaries;

To know how to set your system variables, you can refer to the [Java install guideline](https://www.java.com/en/download/help/path.xml).

<div class="panel panel-default">
<div class="panel-heading"><strong>Installation Troubleshooting</strong></div>
<div class="panel-body">
<div class="accordion" id="accordion2">
<div class="accordion-group">
<div class="accordion-heading">
<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
<strong>I get "command not found" after I installed Jolie under MacOs X El Capitan (10.10.11).</strong>
</a>
<hr>
</div>
<div id="collapseOne" class="accordion-body collapse">
<div class="accordion-inner">

In MacOs X El Capitan (10.10.11) it is not possible to install Jolie
using the default values provided by the installer. When prompted by
the installer, insert e.g., <code>/usr/local/lib/jolie</code> as
the directory of installation of Jolie and <code>/usr/local/bin</code>
as the directory of the launchers.
<hr>
</div>
</div>
</div>
<div class="accordion-group">
<div class="accordion-heading">
<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
<strong>I get "Error: Could not find or load main class jolie.Jolie" after I
installed Jolie under Linux/MacOs X.
</strong>
</a>
</div>
<div id="collapseTwo" class="accordion-body collapse">
<div class="accordion-inner">

The launchers deployed by the installer use the environment variable
<code>JOLIE_HOME</code> to set the classpath and launch Jolie.
As reported by the installer at the end of the installation,
it is possible to set <code>JOLIE_HOME</code> with the command
<code>echo 'export JOLIE_HOME="/usr/lib/jolie"' >> ~/.bash_profile</code>

However, some versions of Linux/MacOs X do not <a
href="http://ss64.com/bash/source.html">source</a> the
<code>.bash_profile</code> file. If, when trying to run Jolie you get the
message <code>"Error: Could not find or load main class jolie.Jolie"</code>, it
could be the case your shell is not sourcing file <code>.bash_profile</code>.
To fix it, edit your <code>.bashrc</code> in you home directory by appending at
its end the line <code>source .bash_profile</code>.

</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div role="tabpanel" class="tab-pane" id="package-managers">

## System Package Managers

You can install Jolie also through system package managers.

### Homebrew (macOS, Linux, Windows 10 WSL)

<a href="http://brew.sh/">Homebrew</a> is a commonly used package manager on
macOS and it is also available for <a
href="https://docs.brew.sh/Homebrew-on-Linux">Linux and Windows 10 WSL systems</a>.

To install Jolie using Homebrew just type <kbd>brew install jolie</kbd> in your terminal.

In case you do not have Homebrew installed in your system, please follow the instructions for <a href="https://brew.sh/">MacOS</a> and 
<a href="https://docs.brew.sh/Homebrew-on-Linux">Linux/Windows 10 WSL</a>.

</div>
<div role="tabpanel" class="tab-pane" id="compile">

## Compilation from Source files

Following these instructions you can download the development version of Jolie
from the official repository. It requires the following software to be installed before
proceeding:

* [JDK (Java SE Development Kit)](http://java.sun.com/javase/downloads/index.jsp);
* [Git](http://git-scm.com/);
* [Maven](https://maven.apache.org/).

<!-- Jump to the instructions for your Operating System:

<div class="text-center">
<a href="#nix"><img style="margin-left: 10px; max-width: 80px;" src="/imgs/os_linux.png" title="Linux" /></a>
<a href="#nix"><img src="/imgs/os_mac.png" style="margin-left: 10px;max-width: 80px;"
title="Mac OS"/></a>
<a href="#windows"><img src="/imgs/os_win.png" style="margin-left: 10px;max-width: 80px;"
 title="Windows"/></a>    
</div> -->

## <a id="nix"></a>Linux and Mac OS

### Clone the repository

<kbd>git clone https://github.com/jolie/jolie.git</kbd>

<kbd>cd jolie</kbd>

<kbd>mvn install</kbd>

This prepares a Jolie installation inside of directory `dist`.

### Set up Jolie for the local user

Now one can use the script `scripts/dev-setup.sh ~/bin` to set up a working 
installation of Jolie for the local user (assuming `~/bin` is in the `$PATH` variable). 
This will create launch scripts in `~/bin` and put all Jolie libraries in `~/bin/jolie-dist`.

## <a id="windows"></a>Windows

Compiling Jolie under Windows requires to work only within the same drive e.g..
`C:`. This is due to limitations of the Java class-loader in locating resources
within different drives.

Open a command line and execute

<kbd>git clone https://github.com/jolie/jolie.git</kbd>

<kbd>cd jolie</kbd>

<kbd>mvn install</kbd>

</div>
<div role="tabpanel" class="tab-pane" id="docker">

## Quick start with pre-built image
This solution requires [Docker](http://www.docker.com) installed in
your machine.

Open a shell and pull the most recent Jolie image with the command <kbd>docker
pull jolielang/jolie</kbd>.

Once the image is available on your machine, create
a container from it by adding a local volume where storing the Jolie files:
<kbd>docker run -it -v /your-host-folder-path:/your-container-path --name
CONTAINERNAME jolielang/jolie</kbd>.

Now you can edit your files in folder
`/your-host-folder-path` and find them in your container folder
`/your-container-path`.

Finally, to run a Jolie microservice type <kbd>jolie your_file.ol</kbd> in the
launched shell.

Containers are also useful to test systems of microservices running within the
same container. To run a new microservice on the same container type
<kbd>docker exec -it CONTAINERNAME bash</kbd> to launch a new shell, following
the previous commands to execute the desired service.

### Running examples in Jolie documentation with Docker
The [Jolie documentation](http://docs.jolie-lang.org/) contains many running examples. With the Jolie Docker image you can run any of these examples without having Jolie directly installed in you OS.

The easiest way to run them is to directly pull the docker image `jolielang/jolie-examples` with command <kbd>docker pull jolielang/jolie-examples</kbd>.

The folder `/examples` of the container includes all the complete examples reported in the documentation (see the related [repository](https://github.com/jolie/examples)).

</div>
<div role="tabpanel" class="tab-pane" id="editors">


## Integrated Development Environments

The listed editors have one or more plug-ins to aid Jolie programmers with syntax highlighting, on-the-fly error notification, and direct in-editor service launch shortcuts.

### Visual Studio Code

The most mature editor support for Jolie is currently offered by the Jolie extension for [Visual Studio Code](https://code.visualstudio.com), called `vscode-jolie`. You can install it directly from within Visual Studio Code or by visiting [https://marketplace.visualstudio.com/items?itemName=jolie.vscode-jolie](https://marketplace.visualstudio.com/items?itemName=jolie.vscode-jolie).

Contributions to the extension are very welcome. See 
[https://github.com/jolie/vscode-jolie](https://github.com/jolie/vscode-jolie) for its code repository.

### Unmaintained Editors

Jolie is supported also by the following editors, although the maintainers of the respective plugins are not maintaining them anymore.

### Atom

Jolie support for the [Atom editor](http://www.atom.io/) can be installed with
the official Atom Package Manager (apm):

<kbd> apm install atom-jolie </kbd>

Contributions to the
[language-jolie](https://github.com/fmontesi/language-jolie) and
[linter-jolie](https://github.com/fmontesi/linter-jolie) packages are welcome.

### Kate

Jolie support for the [Kate editor](http://kate-editor.org/) comes as a file for KatePart (used by most KDE applications and the Kate editor itself). To install it in Kate, download the [latest version](http://www.jolie-lang.org/files/katepart/jolie.xml) of the file and store it within folder `$KDE_HOME/share/apps/katepart/syntax directory`.

You can discover your `$KDE_HOME` directory by issuing the <kbd>kde4 config localprefix</kbd> command.

### Sublime Text

Jolie support for [Sublime Text 2 and 3](http://www.sublimetext.com/) comprises
the [Jolie](https://packagecontrol.io/packages/jolie) plug-in for syntax
highlighting and service launch and
[SublimeLinter-jolint](https://packagecontrol.io/packages/SublimeLinter-jolint)
for on-the-fly error reporting.

Both plug-ins can be installed directly within Sublime Text with [Package Control](https://packagecontrol.io/installation).

</div>
</div>

</div>
