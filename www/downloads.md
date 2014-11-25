<!--Themed-->

# Download and Install

Jolie requires Java to run, so make sure to have [Java](http://www.java.com/) installed before proceeding.

Regardless of the method you choose, after installation executing a Jolie script will be just a matter of invoking the Jolie
interpreter:

<pre>jolie your_file.ol</pre>


## The easy way (binary installer)

This method requires Java 6 (also called Java 1.6) or later to be installed before proceeding.

### Step 1

Download the Java-based installer of the latest stable release of Jolie:

<div class="col-xs-12 text-center">
<a class="download" href="/files/releases/jolie-1.1.jar" 
onclick="_gaq.push(['_trackEvent','Download','JolieInstaller',this.href]);">
Jolie Installer
</a>
</div>


### Step 2

Open a shell terminal. From the directory in which you downloaded the installer,
execute `java -jar jolie-1.1.jar` and follow the on-screen instructions.



## The hard way (compile from sources)

This method will download the development version of Jolie (`trunk`).
It requires the following software to be installed before proceeding:

* JDK (Java SE Development Kit), version 6 or later
* Apache ant
* A subversion client

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
svn co svn://svn.code.sf.net/p/jolie/code/trunk jolie-src
cd jolie-src
ant && sudo ant install
</pre>

The ant script will automatically build and install Jolie for you. The default is to install in `/opt/jolie`, but the 
installation parameters can be controlled by editing `buildconfig/config.properties`.

A Jolie launcher script will be put in `/usr/local/bin` (this parameter is configurable in `buildconfig/config.properties`, too).

### <a id="windows"></a>On Windows

Here are some useful links to get the required tools:

* JDK (Java SE Development Kit): [link](http://java.sun.com/javase/downloads/index.jsp)

* Tortoise Subversion client: [link](http://tortoisesvn.tigris.org/)

* Apache Ant: [link](http://ant.apache.org/).

Download the source code with your svn client from `svn://svn.code.sf.net/p/jolie/code/trunk`

Open the `buildconfig/config.properties` file and change the parameters `install.launcher_dir` and `install.dir` 
by replacing the existing directories with your desired ones. Use `\\` instead of the single backslashes when writing paths.
Here is an example:

<pre>
install.launcher_dir=C:\\Program Files\\jolie
install.dir=C:\\Program Files\\jolie
</pre>

Edit your PATH environment variable so that it includes the `install.launcher_dir` directory.
You can find some instructions on managing environment variables in Windows XP at this
[link](http://support.microsoft.com/kb/310519).

Execute the `ant dist-install` command from inside the directory where you downloaded the source code of Jolie.

### Troubleshooting (Windows)

If the install path contains spaces you will experience a problem in launching the Jolie executable.
This is due to a problem on the command `set joliepath` present in jolie.bat that can be found in
the installation directoy that you specified previously.

To solve this you must substitute the `\` characters before and after the path containing the space with
`//` and include the same part of the path between `""`.

For instance, if you chose to use the same directory as in this tutorial you can correct the `set`
command with the following code.

<pre>
set joliepath=C://"Program Files"//jolie\
</pre>

You can now execute Jolie scripts by issuing the `jolie` command in a console, for example: `jolie your_file.ol`



# Support for external tools

## Kate

Homepage: [http://kate-editor.org/](http://kate-editor.org/)

A syntax highlighting description file for KatePart (which is used by most KDE applications and the Kate editor itself) is available.

Download the [latest version](http://www.jolie-lang.org/files/katepart/jolie.xml) and put it in your `$KDE_HOME/share/apps/katepart/syntax directory`.

You can discover your `$KDE_HOME` directory by issuing the `kde4 config localprefix` command.

## Sublime Text

A bundle for [Sublime Text 2](http://www.sublimetext.com/) with syntax highlighting, code completion, and sublime-build(s) for Jolie.

Refer to this [github repository](https://github.com/thesave/sublime-Jolie) for downloading and installing the latest version.
