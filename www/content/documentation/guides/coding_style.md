##Coding style guidelines

This page lists the basic coding style guidelines for writing Java code in the Jolie project.

The style is not mandatory, but we suggest to follow them for keeping the code of the project consistent and easier to review.
Remember that Jolie is an open source project, and that having a mostly coherent coding style can make the difference between night and day for a person new to the project that is trying to read the code.

Patches improving the style of some existing ugly code are very appreciated.

Indentation

Indentation must be made with tabs, and not spaces! The reference indentation size is 4 spaces. Indentation is one of the most important aspects of making the code readable, so keep it clean.

Newlines

Do not put newlines where they are not necessary, and put newlines when it is useful to logically separate two code blocks.
The following is a good example:
int i = 0;
int n = 100;
OutputStream ostream = new ByteArrayOutputStream();

for( i = 0; i < n; i++ ) {
    ostream.write( i );
}

while the following is bad:
int i = 0;

int n = 100;
OutputStream ostream = new ByteArrayOutputStream();

for( i = 0; i < n; i++ ) {


    ostream.write( i );

}



Names

Class names are to be written in CamelCase. Method and variable names must start with a lower case letter.

Names must be descriptive of their semantics. For instance, a method name should tell what the method does in a clear and concise manner. The same goes for variables and class fields.

Method LOCs

Try not to write too long methods, keeping them readable within one screen (~40 LOCs).
Remember that for splitting code private methods are your friends!
Blocks and statements

Classes

public class MyClass
{
    private int n;

    public MyClass( int n )
    {
         this.n = n;
    }

    public int double()
    {
         return n * 2;
    }
}


If-then-else

if ( condition ) {
    doSomething
} else if ( condition ) {
    doSomethingDifferent
} else {
    doSomethingElse
}


While

while( condition ) {
    statement
}


For and foreach

for( int i = 0; i < n; i++ ) {
    statement
}

for( Value v : vector ) {
    statement
}


Switch

switch( n ) {
case 1:
    statementA;
    break;
case 2:
    statementB;
    statementC;
    break;
default:
    statementD;
    break;
}

