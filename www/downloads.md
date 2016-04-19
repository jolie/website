<!--Themed-->

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
<a href="/files/releases/jolie-1.5.0.jar" onClick="ga('send', 'event', { eventCategory: 'Download', eventAction: 'JolieInstaller', eventLabel: 'jolie-1.5.0.jar'});">
<!-- <button type="button" class="center-block btn btn-default btn-lg"> -->
<p class="download">Jolie Installer</p>
<!-- </button> -->
</a>
</div>
<div class="col-xs-12 text-right">
or download one of the <a href="https://github.com/jolie/website/tree/master/www/files/releases">previous releases</a>.
</div>

### Step 2

Open a shell terminal. From the directory in which you downloaded the
installer, execute `java -jar jolie-1.5.0.jar` and follow the on-screen
instructions.

<p>The installer may need permission to write in the directories in which
you intend to install Jolie. Depending on your Operative System you can
launch the Jolie installer with elevated privileges:

<ul>

<li><strong>on Windows</strong>, by start a command prompt with <a
  href="https://technet.microsoft.com/en-us/library/cc947813.aspx">
  administrator privileges</a> and launch the installer;</li>

<li><strong>on Linux/MacOS</strong>, by launching the installer as root with command
<code>sudo java -jar jolie-1.5.0.jar</code>.

</ul>

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
<code>.bash_profile</code> file. If, when trying to run Jolie you get
the message <code>"Error: Could not find or load main class jolie.Jolie"</code>, it
could be the case your shell is not sourcing file <code>.bash_profile</code>. To
fix it, edit your <code>.bashrc</code> in you home directory by
appending at its end the line <code>source .bash_profile</code>.

</div>
</div>
</div>
</div>
</div>
</div>

<!-- The installer needs permission to write in the directories in which you intend to install Jolie.
Therefore, for example, if you intend to install Jolie in a system directory you may need to launch the installer as root in Linux/MacOS (`sudo java -jar jolie-1.5.0.jar`),
or [administrator in Windows](https://technet.microsoft.com/en-us/library/cc947813.aspx). -->

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

## Atom

Jolie support for the [Atom editor](http://www.atom.io/) can be installed with the official Atom Package Manager (apm):

<pre name="code">
apm install atom-jolie
</pre>

Contributions to the [language-jolie](https://github.com/fmontesi/language-jolie) and [linter-jolie](https://github.com/fmontesi/linter-jolie) packages are welcome.

## Kate

Homepage: [http://kate-editor.org/](http://kate-editor.org/)

A syntax highlighting description file for KatePart (which is used by most KDE applications and the Kate editor itself) is available.

Download the [latest version](http://www.jolie-lang.org/files/katepart/jolie.xml) and put it in your `$KDE_HOME/share/apps/katepart/syntax directory`.

You can discover your `$KDE_HOME` directory by issuing the `kde4 config localprefix` command.

## Sublime Text

A bundle for [Sublime Text 2](http://www.sublimetext.com/) with syntax highlighting, code completion, and sublime-build(s) for Jolie.

Refer to this [github repository](https://github.com/thesave/sublime-Jolie) for downloading and installing the latest version.
