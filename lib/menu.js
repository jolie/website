function replaceAll(txt, replace, with_this) {
  return txt.replace(new RegExp(replace, 'g'),with_this);
}

$(document).ready( function() {
	$.history.init( function( pageName ) {
		if( pageName == "" ) {
			pageName = "home"; // Default content
		}
		$("#nav li a").removeClass( "current" );
		$("#navlink_" + pageName).addClass( "current" );
		$.get( "content/" + pageName + ".html", function(data) {
			$("#content").html( data );
			$("div#syntax").each( function() {
			    var syntax_element = $(this);
			    $.get( "content/syntax/" + $(this).attr("src") + ".html", function(data) {
			      var syntax_content = replaceAll( data,"inputPort", "<b>inputPort</b>");
			      syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			      syntax_content = replaceAll( syntax_content, "type ","<b>type </b>");
			      syntax_content = replaceAll( syntax_content, "outputPort","<b>outputPort</b>");
			      syntax_content = replaceAll( syntax_content, "Location","<b>&nbsp;&nbsp;Location</b>");
			      syntax_content = replaceAll( syntax_content, "Protocol","<b>&nbsp;&nbsp;Protocol</b>");
			      syntax_content = replaceAll( syntax_content, "Interfaces","<b>&nbsp;&nbsp;Interfaces</b>");
			      syntax_content = replaceAll( syntax_content, "interface","<b>interface</b>");
			      syntax_content = replaceAll( syntax_content, "constants","<b>constants</b>");
			      syntax_content = replaceAll( syntax_content, "Redirects","<b>&nbsp;&nbsp;Redirects</b>");
			      syntax_content = replaceAll( syntax_content, "Aggregates","<b>&nbsp;&nbsp;Aggregates</b>");
			      syntax_content = replaceAll( syntax_content, "RequestResponse","<b>&nbsp;&nbsp;RequestResponse</b>");
			      syntax_content = replaceAll( syntax_content, "OneWay","<b>&nbsp;&nbsp;OneWay</b>");
			      syntax_content = replaceAll( syntax_content, "execution","<b>execution</b>");
			      syntax_content = replaceAll( syntax_content, "include","<b>include</b>");
			      syntax_content = replaceAll( syntax_content, "main","<b>main</b>");
			      syntax_content = replaceAll( syntax_content, ",","<b>,</b>");
			      syntax_content = replaceAll( syntax_content, "@","<b>@</b>");
			      syntax_content = replaceAll( syntax_content, "{","<b>{</b>");
			      syntax_content = replaceAll( syntax_content, "}","<b>}</b>");
			      syntax_content = replaceAll( syntax_content, "nullProcess","<b>nullProcess</b>");
			      syntax_content = replaceAll( syntax_content, "throws","<b>throws</b>");
			      syntax_content = replaceAll( syntax_content, "constants","<b>constants</b>");
			      syntax_content = replaceAll( syntax_content, "embedded","<b>embedded</b>");
			      syntax_content = replaceAll( syntax_content, "install","<b>install</b>");
			      syntax_content = replaceAll( syntax_content, "scope","<b>scope</b>");
			      syntax_content = replaceAll( syntax_content, "cset","<b>cset</b>");
			      syntax_content = replaceAll( syntax_content, "if ","<b>if </b>");
			      syntax_content = replaceAll( syntax_content, "for ","<b>for </b>");
			      syntax_content = replaceAll( syntax_content, "else","<b>else</b>");
			      syntax_content = replaceAll( syntax_content, "while","<b>while</b>");
			      syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
			      syntax_content = replaceAll( syntax_content, "\n","<br>");
			      syntax_content = replaceAll( syntax_content, "foreach","<b>foreach</b>");
			      syntax_content = replaceAll( syntax_content, "with","<b>with</b>");
			      syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			      /*var syntax_content = replaceAll( data,"DeploymentInstruction", "<b>DeploymentInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "InputPortInstruction","<b>InputPortInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			      syntax_content = replaceAll( syntax_content, "PortInstruction","<b>PortInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "RedirectionList","<b>RedirectionList</b>");
			      syntax_content = replaceAll( syntax_content, "OutputPortList","<b>OutputPortList</b>");
			      syntax_content = replaceAll( syntax_content, "FaultList","<b>FaultList</b>");
			      syntax_content = replaceAll( syntax_content, "Redirection","<b>Redirection</b>");
			      syntax_content = replaceAll( syntax_content, "OperationIdentifier","<b>OperationIdentifier</b>");
			      syntax_content = replaceAll( syntax_content, "InterfaceDeclaration","<b>InterfaceDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "InterfaceExtensionDeclaration","<b>InterfaceExtensionDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "RequestResponseDeclaration","<b>RequestResponseDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "RequestResponseDefinition","<b>RequestResponseDefinition</b>");
			      syntax_content = replaceAll( syntax_content, "OutputPortDefinition","<b>OutputPortDefinition</b>");
			      syntax_content = replaceAll( syntax_content, "OneWayDeclaration","<b>OneWayDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "CourierDeclaration","<b>CourierDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "BehaviourDeclaration","<b>BehaviourDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "CodeDeclaration","<b>CodeDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "NonDeterministicCourierList","<b>NonDeterministicCourierList</b>");
			      syntax_content = replaceAll( syntax_content, "InputCourierDefinition","<b>InputCourierDefinition</b>");
			      syntax_content = replaceAll( syntax_content, "OneWayList","<b>OneWayList</b>");
			      syntax_content = replaceAll( syntax_content, "RequestResponseList","<b>RequestResponseList</b>");
			      syntax_content = replaceAll( syntax_content, "OneWayDeclaration","<b>OneWayDeclaration</b>");
			      syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
			      syntax_content = replaceAll( syntax_content, "\n","<br>");*/
			      syntax_element.html( syntax_content );
			  });
			});
			$("div#example").each( function() {
			  var example_element = $(this);
			  $.get( "content/examples/" + $(this).attr("src") + ".html", function(data) {
			    var syntax_content = replaceAll( data, "<", "&lt;");
			    syntax_content = replaceAll( syntax_content, ">", "&gt;");
			    syntax_content = replaceAll( syntax_content, "inputPort", "<b>inputPort</b>");
			    syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			    syntax_content = replaceAll( syntax_content, "type","<b>type</b>");
			    syntax_content = replaceAll( syntax_content, "outputPort","<b>outputPort</b>");
			    syntax_content = replaceAll( syntax_content, "Location","<b>&nbsp;&nbsp;Location</b>");
			    syntax_content = replaceAll( syntax_content, "Protocol","<b>&nbsp;&nbsp;Protocol</b>");
			    syntax_content = replaceAll( syntax_content, "Interfaces","<b>&nbsp;&nbsp;Interfaces</b>");
			    syntax_content = replaceAll( syntax_content, "interface","<b>interface</b>");
			    syntax_content = replaceAll( syntax_content, "nullProcess","<b>nullProcess</b>");
			    syntax_content = replaceAll( syntax_content, "constants","<b>constants</b>");
			    syntax_content = replaceAll( syntax_content, "Redirects","<b>&nbsp;&nbsp;Redirects</b>");
			    syntax_content = replaceAll( syntax_content, "Aggregates","<b>&nbsp;&nbsp;Aggregates</b>");
			    syntax_content = replaceAll( syntax_content, "RequestResponse","<b>&nbsp;&nbsp;RequestResponse</b>");
			    syntax_content = replaceAll( syntax_content, "OneWay","<b>&nbsp;&nbsp;OneWay</b>");
			    syntax_content = replaceAll( syntax_content, "execution","<b>execution</b>");
			    syntax_content = replaceAll( syntax_content, "foreach","<b>foreach</b>");
			    syntax_content = replaceAll( syntax_content, "include","<b>include</b>");
			    syntax_content = replaceAll( syntax_content, "main","<b>main</b>");
			    syntax_content = replaceAll( syntax_content, "with","<b>with</b>");
			    syntax_content = replaceAll( syntax_content, "while","<b>while</b>");
			    syntax_content = replaceAll( syntax_content, "embedded","<b>embedded</b>");
			    syntax_content = replaceAll( syntax_content, "install","<b>install</b>");
			    syntax_content = replaceAll( syntax_content, "scope","<b>scope</b>");
			    syntax_content = replaceAll( syntax_content, "throws","<b>throws</b>");
			    syntax_content = replaceAll( syntax_content, "if ","<b>if </b>");
			    syntax_content = replaceAll( syntax_content, "for ","<b>for </b>");
			    syntax_content = replaceAll( syntax_content, "else","<b>else</b>");
			    syntax_content = replaceAll( syntax_content, "cset","<b>cset</b>");
			    syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
			    syntax_content = replaceAll( syntax_content, "\n","<br>");
			    syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			    example_element.html( syntax_content );
			  });
			});
		});
		var languagePageName = pageName.split( "_" )[0];
		if ( languagePageName != "language" ) {
		  $.get( "content/left_standard_bar.html", function(data) {
			$("#left-bar").html( data );
		  });
		} else {
		  $.get( "content/left_language_bar.html", function(data) {
			$("#left-bar").html( data );
		  });
		}
    },
    { unescape: ",/" } );
});

$(document).ready(function() {
	$("#nav li a").click( function() {
		var pageName = this.id.split( "_" )[1];
		$.history.load( pageName );
	});
});

