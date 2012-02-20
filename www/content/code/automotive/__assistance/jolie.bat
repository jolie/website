set joliepath=C:\progra~1\jolie\
set params=%1 %2 %3 %4 %5 %6 %7 %8 %9
java -jar %joliepath%jolie.jar -l %joliepath%lib;%joliepath%javaServices\*;%joliepath%extensions\* -i %joliepath%include %params%
