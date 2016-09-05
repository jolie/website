/* global $:false, jQuery:false, window:false, document:false, alert:false, Prism:false */
"use strict";

// css components in HTML

var css_menu	= "#js_menu";
var css_content = "#js_content";
var css_header	= "#js_header";
var css_site_header = "#js_site_header";

// constants

var adjThs = 10;

// paths to files
var root = "documentation/";
var docs_code_folder = "code/";
var docs_syntax_folder = "syntax/";
var files_menu = "/documentationMenu";

var hash = "#!";
var hashRoot = hash + "documentation/";


// deferred object for handling async load of code in pages
var dfdCode = $.Deferred();
var dfdSyxt = $.Deferred();

// counter and logic for syntax highlighting
// var shc = 0;
// var syntH = {
// 	get: function () { shc += 1; },
// 	put: function () { shc -= 1; if( shc === 0 ){ syntH.run(); } },
// 	run: function () { SyntaxHighlighter.highlight(); }
// };
// SyntaxHighlighter.defaults.toolbar = false;
// SyntaxHighlighter.defaults["auto-links"] = false;

// LAYOUT

// resizes containers to the height of the browser's window
var resizeHeight = function () {
	var window_height = $( window ).height();
	$( css_content ).height( window_height - 
		$( css_header ).outerHeight() - adjThs );
	$( css_menu ).height( window_height - 
		$( css_site_header ).outerHeight() - adjThs );
};

var loadFunctions = function (){
	resizeHeight();
	$( window ).resize( resizeHeight );
	loadMenu();
};

// DOCUMENTS LOGIC

var loadMenu = function() {
	$.getJSON( files_menu, function(json, textStatus) {
			var menu = createMenu( json.topics );
			$( css_menu ).html( menu );
			addIdToJSL();
			// also loads the default page
			window.onhashchange = checkUrl;
			checkUrl();
	});
};

var checkUrl = function () {
	var url = window.location.toString();
	var anchor = "";
	var e = null;
	if( url.indexOf( hashRoot ) > -1 ){
		url = url.match(/#!documentation\/(.+)/)[1];
		var i = url.indexOf( "#" );
		if( i > -1 ){
			anchor = url.substring( i, url.length );
			url = url.substring( 0, i );
		}
		url = hashRoot + url;
		e = {
			target: $( css_menu ).find( "a[href=\"" + url + "\"]" )
		};
	} else {
		e = {
			target: $( css_menu ).find( "a[href=\"#!documentation/getting_started/hello_world.html\"]" )
		};
	}
	loadMenuItem( e, true, anchor );
};

var pushUrl = function( url ){
	history.pushState( null, null, url );
};

var addIdToJSL = function () {
	var jslEl = $( css_menu ).find( "span:contains(\"Standard Library API\")" );
	$( jslEl ).attr( "id", "jsl" );
};

var createMenu = function ( json ) {
	var ul = $( "<ul></ul>" );
	$( json ).each( function( i, el ) {
		createMenuItem( ul, el );
	});
	return ul;
};

var createMenuItem = function ( ul, el ) {
	$( el ).each( function ( i, e ) {
		var li = $( "<li></li>" );
		li.html( $( "<span></span>").text( e.label ) );
		createItems( li, e.children );
		ul.append( li );
	});
};

var createItems = function ( el, children ){
	var ul = $( "<ul></ul>" );
	$( children ).each( function( i, e ) {
		var li = $( "<li></li>" );
		var a = $( "<a></a>" ).attr( "href", hashRoot + e.url );
		// every link returns itself to loadMenuItem
		a.attr( "onclick", "return loadMenuItem( event );" );
		a.text( e.label );
		$( li ).append( a );
		$( ul ).append( li );
	});
	$( el ).append( ul );
};

var loadMenuItem = function( event, noPush, anchor ){
	$( css_menu ).find( ".menu_selected" ).each( function(i, e) {
		$( e ).attr( "class", "" );
	});
	var el = $( event.target );
	el.attr( "class" , "menu_selected" );
	var par = $( el ).parent().parent();
	while( par.prop( "tagName" ).toLowerCase() != "li" ){
		par = par.parent();
	}
	updateBreadcrumb( el, par );
	var href = el.attr( "href" );
	// strip !#documentation if present
	if( href.indexOf( hashRoot ) > -1 ){
		href = href.substring( hashRoot.length, href.length );
	}
	var doc = root + href;
	$.get( doc, function( data ) {
		var html = $( "<div></div>" ).append( data );
		$( html ).find( "style" ).remove();
		$( css_content ).html( html );

		$.when( dfdSyxt ).done( function (){
			$( css_content ).scrollTop( 0 );
			scrollToElement( anchor );
		});
		
		loadCode( href );
		loadSyntax( href );
		addTOCToParent( el );
		updateInternalLinks( $( css_content ) );
		updateAnchors( $( css_content ) );
		if( !noPush ){
			pushUrl( hash + doc );
		}
	});
	return false;
};

var updateInternalLinks = function ( c ) {
	$( c ).find( "a[href]" ).each( function(i, a) {
		var href = $( a ).attr( "href" );
		if( href.charAt( 0 ) != "/" 		&& 
			href.indexOf( "http://" ) < 0 && 
			href.indexOf( "https://" ) < 0 && 
			href.indexOf( "documentation" ) < 0 && 
			href.charAt( 0 ) != "#" ){
			$( a ).attr( "href", hashRoot + href );
		}
	});
};

var updateAnchors = function ( c ){
	$( c ).find( "a[href]" ).each( function( i, a ) {
		var href = $( a ).attr( "href" );
		if( href.charAt( 0 ) === "#" && href.charAt( 1 ) != "!" ){
			$( a ).attr( "onclick", 
				"return scrollToElement(\"*[id='" + href.substring(1,href.length) + "']\")" );
		}
	});
};

var addTOCToParent = function ( el ) {
	// we do not add the TOC to APIs
	var par = $( el ).parent().parent();
	while( par.prop( "tagName" ).toLowerCase() != "li" ){
		par = par.parent();
	}
	if( par.find( "span" ).text() != "Standard Library API" ){

		$( css_menu ).find( ".TOC" ).each( function( i, e ) {
		$( e ).remove();
		});
		var ul = $( "<ul></ul>" ).attr( "class", "TOC" );
		$( css_content ).find( "h2" ).each( function( i, e ) {
			var href = "/" + $( el ).attr( "href" ) + "#" + $( e ).attr( "id" );
			ul.append( $( "<li></li>" )
				.append( $( "<a></a>")
					.attr( "href", href )
					.attr( "onclick", "return tocClick(\"" + "#" + $( e ).attr( "id" ) + 
						"\",\"" + href + "\")" )
					.text( $( e ).text() ).click( function( event ) {
						$( css_menu ).find( ".toc_selected" ).each( function(i, e) {
							$( e ).attr( "class", "" );
						});
						var sube = $( event.target );
						sube.attr( "class" , "toc_selected" );
					}) ) );
		});
		el.parent().append( ul );
	}
};

var tocClick = function( el, href ) {
	pushUrl( href );
	scrollToElement( el );
	return false;
};

var scrollToElement = function ( el ) {
	if( typeof $( el ).offset() !== typeof undefined ){
		$( css_content ).scrollTop( 0 );
		var threshold = 20;
		var diff = $( el ).offset().top - $( css_content ).offset().top;
		if( diff > threshold ){
			$( css_content ).scrollTop( diff );
		}
		$( el ).attr( "class", "highlight" );
		setTimeout( function() {
			$( el ).attr( "class", "");
		},500);
		return false;
	}
};

var loadCode = function ( href ) {
	var parent_folder = href.match(/(.+\/)/)[0];
	var codeToLoad = $( css_content ).find( ".code" ).length;
	if ( codeToLoad === 0 ){ dfdCode.resolve(); }
	$( css_content ).find( ".code" ).each( function( i, el ) {
		var src = $( el ).attr( "src" );
		if ( typeof src !== typeof undefined && src !== false ){
			var file = $( el ).attr( "src" );
			var path = root + parent_folder + docs_code_folder + file;
			$.get( path , function( data ) {
				$( el ).html( $( "<pre></pre>" ).append(
						$( "<code></code>" ).text( data ) )
					.attr("class", "line-numbers language-" + getLangFromExt( file ) ) );
				Prism.highlightElement( $( el ).find( "pre code" )[0] );
				if ( --codeToLoad === 0 ){ dfdCode.resolve(); }
			}, "text");
	} else {
		$( el ).html( $( "<pre></pre>" )
					.attr("class", "language-" + $( el ).attr( "lang" ) )
					.text( $( el ).text() ) );
		if ( --codeToLoad === 0 ){ dfdCode.resolve(); }
	}
});};

var loadSyntax = function ( href ) {
	var parent_folder = href.match(/(.+\/)/)[0];
	var sytxToLoad = $( css_content ).find( ".syntax" ).length;
	if( sytxToLoad === 0 ){ dfdSyxt.resolve(); }
	$( css_content ).find( ".syntax" ).each( function( i, el ) {
		// syntH.get();
		var file = $( el ).attr( "src" );
		var path = root + parent_folder + docs_syntax_folder + file;
		$.get( path , function( data ) {
			$( el ).html( $( "<pre></pre>" )
				// .attr("class", "brush: " + getLangFromExt( file ) )
				.text( data ) );
			// syntH.put();
			if( --sytxToLoad === 0 ){ dfdSyxt.resolve(); }
		}, "text" );
	});
};

var getLangFromExt = function ( fileName ) {
	var ext = fileName.substring(fileName.lastIndexOf(".") + 1);
	if (extLang.ext[ext] && extLang.ext[ext].lang) {
	    return extLang.ext[ext].lang;
	} else {
	    return "jolie";
	}
};

var updateBreadcrumb = function ( el, parent ) {
	var bc = $( css_header ).find( ".breadcrumb ").html("");
	bc.append( $( "<li></li>" ).text( parent.find( "span" ).text() ) );
	bc.append( $( "<li></li>" ).text( el.text() ).attr( "class", "active" ) );
};

var extLang = {
  "ext": {
  	"xml": 	{ "lang": "markup" },
    "html": { "lang": "markup" },
    "json": { "lang": "jscript" },
    "js": 	{ "lang": "jscript" },
    "ol": 	{ "lang": "jolie" },
    "iol": 	{ "lang": "jolie" },
    "java": { "lang": "java" },
    "txt": 	{ "lang": "plain" }
  }
};

// Loaded on start
$( document ).ready( loadFunctions() );