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
			      var syntax_content = replaceAll( data,"DeploymentInstruction", "<b>DeploymentInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "InputPortInstruction","<b>InputPortInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			      syntax_content = replaceAll( syntax_content, "PortInstruction","<b>PortInstruction</b>");
			      syntax_content = replaceAll( syntax_content, "RedirectionList","<b>RedirectionList</b>");
			      syntax_content = replaceAll( syntax_content, "Redirection","<b>Redirection</b>");
			      syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
			      syntax_content = replaceAll( syntax_content, "\n","<br>");
			      syntax_element.html( syntax_content );
			  });
			});
			$("div#example").each( function() {
			  var example_element = $(this);
			  $.get( "content/examples/" + $(this).attr("src") + ".html", function(data) {
			    var syntax_content = replaceAll( data,"inputPort", "<b>inputPort</b>");
			    syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
			    syntax_content = replaceAll( syntax_content, "outputPort","<b>outputPort</b>");
			    syntax_content = replaceAll( syntax_content, "Location","<b>&nbsp;&nbsp;Location</b>");
			    syntax_content = replaceAll( syntax_content, "Protocol","<b>&nbsp;&nbsp;Protocol</b>");
			    syntax_content = replaceAll( syntax_content, "Interfaces","<b>&nbsp;&nbsp;Interfaces</b>");
			    syntax_content = replaceAll( syntax_content, "Redirects","<b>&nbsp;&nbsp;Redirects</b>");
			    syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
			    syntax_content = replaceAll( syntax_content, "\n","<br>");
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

