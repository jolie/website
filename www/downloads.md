<!--Themed-->

<!--<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container">
<ul class="nav nav-pills">
<li role="presentation"><a href="#download-and-install">Download and Install</a></li>
<li role="presentation"><a href="/downloads.html">Download & Install</a></li>
<li role="presentation"><a href="/news">News</a></li>
</ul>
  </div>
</nav>

<div class="dropdown">
  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" 
aria-expanded="true">
  Dropdown
  <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
  </ul>
</div>

<div class="span12 page-nav-menu vertical-align nav-bar-static-top">
<div class="span3"><strong>In this page:</strong></div>
<div class="span9 dropdown">
<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" 
aria-expanded="true">
Download and Install
<span class="caret"></span>
</button>
  <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
<!--   <li role="presentation"><a role="menuitem" tabindex="-1" href="#download-and-install">Top</a></li> -->
  <!--<li role="presentation"><a role="menuitem" tabindex="-1" href="#the-easy-way">The easy way (binary installer)</a></li>
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
  <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
  </ul>

<ul class="nav nav-pills">
<li role="presentation"><a href="#download-and-install">Download and Install</a></li>
<li role="presentation"><a href="/downloads.html">Download & Install</a></li>
<li role="presentation"><a href="/news">News</a></li>
</ul>
</div>
</div>-->

# <a id="download-and-install"></a> Download and Install

Jolie requires Java to run, so make sure to have [Java](http://www.java.com/) installed before proceeding.

Regardless of the method you choose, after installation executing a Jolie script will be just a matter of invoking the Jolie
interpreter:

<pre>jolie your_file.ol</pre>


## The easy way (binary installer)

This method requires Java 6 (also called Java 1.6) or later to be installed before proceeding.

### Step 1

Download the Java-based installer of the latest stable release of Jolie:

<div class="col-xs-12 text-center">
<a href="/files/releases/jolie-1.2.1.jar" onClick="ga('send', 'event', { eventCategory: 'Download', eventAction: 'JolieInstaller', eventLabel: 'jolie-1.2.1.jar'});">
<!-- <button type="button" class="center-block btn btn-default btn-lg"> -->
<p class="download">Jolie Installer</p>
<!-- </button> -->
</a>
</div>


### Step 2

Open a shell terminal. From the directory in which you downloaded the installer,
execute `java -jar jolie-1.2.1.jar` under windows or
`java -jar jolie-1.2.1.jar` under MacOs or Linux and follow the on-screen instructions.

The installer needs permission to write in the directories in which you intend to install Jolie.
Therefore, for example, if you intend to install Jolie in a system directory you may need to launch the installer as root in Linux/MacOS (`sudo java -jar jolie-1.2.1.jar`),
or [administrator in Windows](https://technet.microsoft.com/en-us/library/cc947813.aspx).

## The hard way (compile from sources)

This method will download the development version of Jolie (`trunk`).
It requires the following software to be installed before proceeding:

* JDK (Java SE Development Kit), version 6 or later
* Apache ant
* Git

<div style="float:left">
<p>Jump to the instructions for your Operating System:
<a href="#nix"><img src="/imgs/os_linux.png" title="Linux" height="80px"/></a>
<a href="#nix"><img src="/imgs/os_mac.png" title="Mac OS" height="80px"/></a>
<a href="#windows"><img src="/imgs/os_win.png" title="Windows" height="80px"/></a>
</p>
</div>

<div style="clear: both;"></div>

### <a id="nix"></a>Linux and Mac OS

Open a shell and execute:

<pre name="code">
git clone https://github.com/jolie/jolie.git
cd jolie
ant && sudo ant install
</pre>

The ant script will automatically build and install Jolie for you. The default is to install in `/usr/lib/jolie`, but 
the installation parameters can be controlled by editing `buildconfig/config.properties`.

A Jolie launcher script will be put in `/usr/bin` (this parameter is configurable in 
`buildconfig/config.properties`, too).

Remember to follow the on-screen instructions at the end of the installation procedure, about the environment variables.

### <a id="windows"></a>On Windows

Please make sure to work only on a single drive eg. `C:`, otherwise the Java
classloader ends up in difficulties locating resources like include files
(`console.iol` etc.)!

Here are some useful links to get the required tools:

* JDK (Java SE Development Kit): [link](http://java.sun.com/javase/downloads/index.jsp)

* Git client: [link](http://git-scm.com/)

* Apache Ant: [link](http://ant.apache.org/).

Download the source code with Git from `https://github.com/jolie/jolie.git`

Open the `buildconfig/config.properties` file and change the parameters `install.launcher_dir` and `install.dir` 
by replacing the existing directories with your desired ones. Use `\\` instead of the single backslashes when writing
paths. Here is an example:

<pre>
install.launcher_dir=C:\\Windows\\system32
install.dir=C:\\Jolie
</pre>

If you change the directory for `install.launcher_dir`, make sure that it is included in your your PATH environment variable.
You can find some instructions on managing environment variables in Windows XP at this
[link](http://support.microsoft.com/kb/310519). Please note that using paths with spaces may cause problems in Windows and need special handling.

Execute the `ant dist-install` command from inside the directory where you downloaded the source code of Jolie.
Follow the on-screen instructions at the end of the installation procedure about the environment variables.
In particular, you should make sure that the environment variable `JOLIE_HOME` is set to the directory you used for `install.dir`.

<!--
### Troubleshooting (Windows)

If the install path contains spaces you may experience a problem in launching the Jolie executable.
This is due to a problem on the command `set JOLIE_HOME` present in jolie.bat that can be found in
the installation directoy that you specified previously.

To solve this you must substitute the `\` characters before and after the path containing the space with
`//` and include the same part of the path between `""`.

For instance, if you chose to use the same directory as in this tutorial you can correct the `set`
command with the following code.

<pre>
set joliepath=C://"Program Files"//jolie\
</pre>

You can now execute Jolie scripts by issuing the `jolie` command in a console, for example: `jolie your_file.ol`
-->


# Support for external tools

## Kate

Homepage: [http://kate-editor.org/](http://kate-editor.org/)

A syntax highlighting description file for KatePart (which is used by most KDE applications and the Kate editor itself) is available.

Download the [latest version](http://www.jolie-lang.org/files/katepart/jolie.xml) and put it in your `$KDE_HOME/share/apps/katepart/syntax directory`.

You can discover your `$KDE_HOME` directory by issuing the `kde4 config localprefix` command.

## Sublime Text

A bundle for [Sublime Text 2](http://www.sublimetext.com/) with syntax highlighting, code completion, and sublime-build(s) for Jolie.

Refer to this [github repository](https://github.com/thesave/sublime-Jolie) for downloading and installing the latest version.
