<div class="scrollable_container nano">

# Install

## Linux

### openSuse - one click installation

[openSuse 11.3](http://download.opensuse.org/repositories/home:/fmontesi/openSUSE_11.3/jolie.ymp)

### From sources
Requirements:

- Java SDK >=1.6
- Apache ant
- Subversion client 

Open a shell and execute:

<div class="code" src="example_install_1.txt"></div>

The ant script will automatically build and install Jolie for you. The default is to install in /opt/jolie, but the 
installation parameters can be controlled by editing buildconfig/config.properties.

A Jolie launcher script will be put in `/usr/local/bin` (this parameter is configurable, too), thus executing a Jolie script will be just a matter of:

<div class="code" src="example_install_2.txt"></div>

---

## Windows

### From sources

#### Requirements:

Install the latest JDK (Java SE Development Kit) from this [link](http://java.sun.com/javase/downloads/index.jsp) Install a Subversion client (e.g. [Tortoise](http://tortoisesvn.tigris.org/))

Install Ant for building sources from this [link](http://ant.apache.org/).

#### Installing:

Download JOLIE's sources with your svn client from <https://jolie.svn.sourceforge.net/svnroot/jolie/trunk>

Go into the trunk directory.

Open the buildconfig/config.properties file and change the parameters `install.launcher_dir` and `install.dir` 
by replacing the existing directories with your desired ones. Use `\\` instead of the single backslashes when writing paths. Example:

<div class="code" src="example_install_3.txt"></div>

Edit your PATH environment variable so that it includes the `install.launcher_dir` directory [instructions for managing environment variables under Windows XP](http://support.microsoft.com/kb/310519) 
Execute the `ant dist install` command.

If the install path contains spaces you will experience a problem in launching the jolie executable. This is due to a problem on the command `set joliepath` present in jolie.bat that can be found in the intall directoy that you have previously specified.

To solve this you must substitute the `\` characters before and after the path containing the space with `//` and include the same part of the path between `""`.

For instance, if you did choose to use the same directory of this tutorial you can correct the `set` command with the following code.

<div class="code" src="example_install_4.txt"></div>

You can now execute Jolie scripts by issuing the jolie command to a console, e.g.:

<div class="code" src="example_install_5.txt"></div>

---

## Support for external tools

### Kate
Homepage: [http://kate-editor.org/](http://kate-editor.org/)

A syntax highlighting description file for KatePart (which is used by most KDE applications and the Kate editor itself) is available.

Download the [latest version](http://jolie.svn.sourceforge.net/viewvc/jolie/trunk/support/katepart/syntax/jolie.xml) and put it in your `$KDE_HOME/share/apps/katepart/syntax directory`.

You can discover your `$KDE_HOME` directory by issuing the kde4 config localprefix command.

</div>