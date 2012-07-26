$(document).ready( function() {
	var left = $("#content").offset().left + $("#content").width();
	$("#go_on_top").css( "bottom", 0 );
	$("#go_on_top").css( "left", left );
	
	$("#go_on_top").click( function() {
		scrollToPosition( 0 );
	});
	$(window).scroll( function() {
		var topSpan = $("#go_on_top");
		if ( $(window).scrollTop() > 0 ) {
			if ( !topSpan.is( ":visible" ) ) {
				$("#go_on_top").fadeIn( 300 );
			}
		} else {
			if ( topSpan.is( ":visible" ) ) {
				$("#go_on_top").fadeOut( 300 );
			}
		}
	});
});

function scrollToId( id )
{
	scrollToPosition( $("#"+id).offset().top );
}

function scrollToPosition( top )
{
	$("html,body").animate( { scrollTop: top }, "slow" );
}

var NAV_TOKEN = "__page_";

function applyTransformations()
{
	initLinks();
	initDownloads();
}

function initDownloads()
{
	$("div#download a").each( function() {
		var a = $(this);
		a.html(
			"<img src=\"images/download.png\" height=\"50\" style=\"margin-right:10px\"/>Download"
		);
	});
}

function initLinks()
{
	var navClickFunction = function() {
		var pageName = this.id.slice( this.id.indexOf( "_" ) + 1 );
		$.history.load( NAV_TOKEN + pageName );
	};

	$("body").off( "click.navigation", "a[id^=navlink_]" );
	$("body").on( "click.navigation", "a[id^=navlink_]", navClickFunction );
// 	$("body > a[id^=navlink_]").css( "cursor", "hand" );
	$("body a[id^=navlink_]").css( "cursor", "pointer" );

	var innerLinksClick = function() {
		var jump = $(this).attr( "href" );
		var new_position = $( "a[name=" + jump.slice( 1 ) + "]" ).offset();
		if ( new_position ) {
			scrollToPosition( new_position.top );
		}
		return false;
	};
	$("body").off( "click.href", "a[href^=#]" );
	$("body").on( "click.href", "a[href^=#]", innerLinksClick );
}

function replaceAll( txt, replace, with_this )
{
	return txt.replace( new RegExp( replace, 'g' ), with_this );
}

function parseExample( data )
{
	var syntax_content = replaceAll( data, "<", "&lt;");
	syntax_content = replaceAll( syntax_content, ">", "&gt;");
	syntax_content = replaceAll( syntax_content, "inputPort", "<b>inputPort</b>");
	syntax_content = replaceAll( syntax_content, "--","&nbsp;&nbsp;");
	syntax_content = replaceAll( syntax_content, "type","<b>type</b>");
	syntax_content = replaceAll( syntax_content, "outputPort","<b>outputPort</b>");
	syntax_content = replaceAll( syntax_content, "Location:","<b>&nbsp;&nbsp;Location</b>:");
	syntax_content = replaceAll( syntax_content, "Protocol:","<b>&nbsp;&nbsp;Protocol</b>:");
	syntax_content = replaceAll( syntax_content, "Interfaces:","<b>&nbsp;&nbsp;Interfaces</b>:");
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
	syntax_content = replaceAll( syntax_content, "init","<b>init</b>");
	syntax_content = replaceAll( syntax_content, "throw","<b>throw</b>");
	syntax_content = replaceAll( syntax_content, "scope","<b>scope</b>");
	syntax_content = replaceAll( syntax_content, "throws","<b>throws</b>");
	syntax_content = replaceAll( syntax_content, "if ","<b>if </b>");
	syntax_content = replaceAll( syntax_content, "for ","<b>for </b>");
	syntax_content = replaceAll( syntax_content, "else","<b>else</b>");
	syntax_content = replaceAll( syntax_content, "cset","<b>cset</b>");
	syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
	syntax_content = replaceAll( syntax_content, "\n","<br/>");
	syntax_content = replaceAll( syntax_content, "true","<b>true</b>");
	syntax_content = replaceAll( syntax_content, "false","<b>false</b>");
	
	/*
	 * Highlight comments with gray. This needs to be refined,
	 * since it does not allow for " to appear inside comments.
	 * " is disallowed because we may be inside a string containing
	 * the characters //, and we do not want to color those with gray.
	 */
	syntax_content = syntax_content.replace( /(\/\/[^"]*?)(?=<br\/>)/g, "<span style=\"color:gray\">$1</span>" );
	
	return syntax_content;
}

$(document).ready( function() {
	$.history.init( function( historyToken ) {
		if( historyToken == "" ) {
			historyToken = NAV_TOKEN + "home"; // Default content
		}

		if ( historyToken.slice( 0, NAV_TOKEN.length ) != NAV_TOKEN ) {
			return;
		}
		
		var pageName = historyToken.slice( NAV_TOKEN.length );

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
		// $("#nav li a").removeClass( "current" );
		// $("#navlink_" + pageName).addClass( "current" );
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
					syntax_content = replaceAll( syntax_content, "throw","<b>throw</b>");
					syntax_content = replaceAll( syntax_content, "constants","<b>constants</b>");
					syntax_content = replaceAll( syntax_content, "embedded","<b>embedded</b>");
					syntax_content = replaceAll( syntax_content, "install","<b>install</b>");
					syntax_content = replaceAll( syntax_content, "init","<b>init</b>");
					syntax_content = replaceAll( syntax_content, "scope","<b>scope</b>");
					syntax_content = replaceAll( syntax_content, "cset","<b>cset</b>");
					syntax_content = replaceAll( syntax_content, "if ","<b>if </b>");
					syntax_content = replaceAll( syntax_content, "for ","<b>for </b>");
					syntax_content = replaceAll( syntax_content, "scope","<b>scope</b>");
					syntax_content = replaceAll( syntax_content, "else","<b>else</b>");
					syntax_content = replaceAll( syntax_content, "while","<b>while</b>");
					syntax_content = replaceAll( syntax_content, "=>","<b>=></b>");
					syntax_content = replaceAll( syntax_content, "\n","<br/>");
					syntax_content = replaceAll( syntax_content, "foreach","<b>foreach</b>");
					syntax_content = replaceAll( syntax_content, "with","<b>with</b>");
					syntax_content = replaceAll( syntax_content, "true","<b>true</b>");
					syntax_content = replaceAll( syntax_content, "false","<b>false</b>");
					syntax_element.html( syntax_content );
				});
			});
			$("div#example").each( function() {
				var example_element = $(this);
				var src = example_element.attr("src");
				if ( src ) {
					$.get( "content/examples/" + src + ".html", function(data) {
						example_element.html( parseExample( data ) );
					});
				} else {
					example_element.html( parseExample( example_element.html() ) );
				}
			});
			
			$("div#code").each( function() {
				var el = $(this);
				var src = el.attr("src");
				if ( src ) {
					$.get( "content/code/" + src, function(data) {
						var content = parseExample( data );
						content = replaceAll( content, "\t","&nbsp;&nbsp;");
						el.html( content );
					});
				} else {
					var content = parseExample( el.html() );
					content = replaceAll( content, "\t","&nbsp;&nbsp;");
					el.html( content );
				}
			});
			applyTransformations();
			scrollToPosition( 0 );
		});
	},
	{ unescape: ",/" } );
});