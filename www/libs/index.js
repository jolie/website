var content_folder = "content/";
var documentation_folder = content_folder + "documentation/";
var visited_menu = false;

var ext_to_lang_hash = {
    "ext": {
        "xml": {
            "lang": "xml"
        },
        "html": {
            "lang": "xml"
        },
        "json": {
            "lang": "jscript"
        },
        "js": {
            "lang": "jscript"
        },
        "ol": {
            "lang": "jolie"
        },
        "iol": {
            "lang": "jolie"
        },
        "java": {
            "lang": "java"
        }
    }
};

$(document).ready(function() {
    SyntaxHighlighter.defaults.toolbar = false;
    adjustHeights();
    History.Adapter.bind(window, "statechange", history);
    history();
});

// GENERAL FUNCTIONS
$(window).resize(function() {
    $("#menu_content").css("height", "auto");
    adjustHeights();
});

function history() {
    var url = History.getState().url;
    if (url.indexOf("#") > -1) {
        url = url.substring(0, url.indexOf("#"));
    }
    var url_params = URL2jParam(url);
    if (!url_params.top_menu) {
        menu($("a[ref='news']"));
    } else if (url_params.top_menu == "documentation" && url_params.side_menu) {
        if (!visited_menu) {
            menu($("a[ref='documentation']"));
            openTopic($('#doc_side_menu'), url_params.side_menu);
        }
        load_doc_content(url_params.side_menu);
    } else if (url_params.top_menu == "community") {
        menu($("a[ref='community']"));
        if (!url_params.side_menu) {
            side_menu('community', 'people')
        } else {
            load_community_content("li[ref='" + url_params.side_menu + "']", url_params.side_menu);
        }
    } else if (url_params.top_menu == "about_jolie") {
        menu($("a[ref='about_jolie']"));
        if (!url_params.side_menu) {
            side_menu('about_jolie', 'contacts')
        } else {
            load_about_jolie_content("li[ref='" + url_params.side_menu + "']", url_params.side_menu);
        }
    } else {
        menu($("a[ref='" + url_params.top_menu + "']"));
    }
}

function top_menu(el) {
    History.pushState(null, null, "?top_menu=" + $(el).attr("ref"));
    TOCCreator(false);
}

function URL2jParam(url) {
    jParam = {};
    var uParams = url.substring(url.indexOf("?") + 1);
    uParams = uParams.split("&");
    $.each(uParams, function(key, sParam) {
        var key = sParam.substring(0, sParam.indexOf("="));
        var value = sParam.substring(sParam.indexOf("=") + 1);
        jParam[key] = value;
    });
    return jParam;
}

function adjustDocPrintHeight(){
    var content_height=0;
    $.each($(".content > *"),function() {
        var eh = $(this).outerHeight(true);
        content_height += parseInt(eh);
    });
    $("style").html("@media print{#menu_content{display: block; height:"+content_height+"px !important;}}");
}

function adjustHeights() {
    menu_content_h = $("#menu_content").height();
    var body_h = $("body").height();
    var header_h = $("#header").height();
    var subheader_h = $("#subheader").height()
    var footer_h = $("#footer").height();
    var menu_content_h = body_h - (header_h + subheader_h + footer_h);
    $("#menu_content").height(menu_content_h);
}

function error_page(errorType, textStatus, errorThrown) {
    $("#menu_content").html("<div style=\"margin-top:50px\" " + "class=\"grid_14 push_8\"><h1>404</h1>" + "<h3>Text Status</h3><p>" + textStatus + "</p>" + "<h3>Error Thrown</h3><p>" + errorThrown + "</p>" + "<img style=\"width:100px;\"" + "src=\"../imgs/jolie_logo.png\"></div>");
}

function menu(elem) {
    if (!$(elem).attr("src")) {
        error_page();
    } else {
        $("#top_menu *").each(function(i, e) {
            $(e).removeAttr("id");
        });
        $(elem).attr("id", "active");
        $.ajaxSetup({
            async: false
        });
        visited_menu = true;
        loadMenuContent($(elem).attr("src"));
        if ($(elem).attr("ref") == "documentation") {
            doc_load_side_menu();
            zen_menu(true);
        } else if ($(elem).attr("ref") == "about_jolie" || $(elem).attr("ref") == "community") {
            zen_menu(true);
        } else {
            zen_menu(false);
        }
        $.ajaxSetup({
            async: true
        });
    }
}

function scrollify(element) {
    $.each($(element), function(key, e) {
        var content = $(e).html();
        $(e).html("<div class=\"content\">" + content + "</div>");
        $(e).addClass("nano");
        $(e).nanoScroller();
    });
}

function zen_menu(zen) {
    var color = ""
    if (zen) {
        color = "#DDD"
    }
    $("#logo-down").css("background-color", color);
}

function loadMenuContent(content_path) {
    $.ajax({
        url: content_folder + content_path,
        success: function(data) {
            $("#menu_content").html(data);
            scrollify(".scrollable_container");
            loadCode(content_folder + content_path.split("/")[0] + "/");
        },
        error: function(errorType, textStatus, errorThrown) {
            error_page(errorType, textStatus, errorThrown);
        }
    });
}

function load_generic_content(content_path, dom_location) {
    $.ajax({
        url: content_folder + content_path,
        success: function(data) {
            $(dom_location).html(data);
            scrollify(".scrollable_container");
        },
        error: function(errorType, textStatus, errorThrown) {
            error_page(errorType, textStatus, errorThrown);
        }
    });
}

// DOCUMENTATION FUNCTIONS

function doc_load_side_menu() {
    $.ajax({
        url: documentation_folder + "menu.json",
        dataType: 'json',
        success: function(data) {
            $('#doc_side_menu').html("");
            $('#doc_side_menu').tree({
                data: add_id(data),
                autoOpen: false,
                selectable: true
            });
            load_menu_events();
        },
        error: function(errorType, textStatus, errorThrown) {
            error_page(errorType, textStatus, errorThrown);
        }
    });
}

function add_id(json) {
    var id = 1;
    $.each(json, function(ti, topic) {
        $.each(topic.children, function(ni, node) {
            json[ti].children[ni]["id"] = id++;
        })
    });
    return json;
}

function load_menu_events() {
    $('#doc_side_menu').bind('tree.click', function(event) {
        var node = event.node;
        if (typeof node.url != "undefined") {
            History.pushState("", "", "?top_menu=documentation&side_menu=" + node.url);
        } else {
            $("#doc_side_menu").tree('toggle', node);
            $(".jqtree-selected").removeClass("jqtree-selected");
        }
    });
}

function pushDocLink(page_name) {
    visited_menu = false;
    History.pushState("", "", "?top_menu=documentation&side_menu=" + page_name);
}

function parseAnchors() {
    $.each($("#doc_content a"), function() {
        if(!$(this).parent().hasClass("download")){
            var link = $(this).attr("href");
            $(this).removeAttr("href");
            $(this).attr("onclick", "pushDocLink('" + link + "');");
        }
        else{
            var link = $(this).attr("href");
            var dom = History.getState().url.split("?")[0];
            $(this).attr("href",dom+content_folder+link);
        }
    });
}

function setLoading( element ){
    $( element ).html( "<div class=\"ajax_load\"></div>");
}

function load_doc_content(content_path) {
    setLoading("#doc_content");
    $.ajax({
        url: documentation_folder + content_path + ".html",
        error: function(errorType, textStatus, errorThrown) {
            error_page();
        },
        success: function(data) {
            $("#doc_content").append("<div class=\"temp\">" + data + "<div>");
            loadCode( documentation_folder + content_path.split("/")[0] + "/");
            // ->   these last functions must be called when
            //      all source codes are loaded
            //parseAnchors();
            //TOCCreator(true);
            //SyntaxHighlighter.highlight();
            //scrollify("#doc_content");
            //adjustDocPrintHeight();
        }
    });
}

function load_callback(){
    code_to_load--;
    if ( code_to_load <= 0){
        $("#doc_content").html( $( ".temp" ).html() );
        parseAnchors();
        TOCCreator( true );
        SyntaxHighlighter.highlight();
        scrollify( "#doc_content" );
        adjustDocPrintHeight();
    }
}

function loadCode( folder ) {
    code_to_load = $("div.syntax, div.code").size();
    if (typeof folder == "undefined") {
        folder = documentation_folder;
    }
    $("div.syntax, div.code" ).each(function() {
        var el = $(this);
        var src_file = el.attr("src");
        // IF SOURCE HAS TO BE LOADED
        if (src_file) {
            // IF IT'S IN SYNTAX
            var content = "";
            if (el.hasClass("syntax")) {
                $.get(folder + "syntax/" + src_file, function(data) {
                    content = data;
                    el.after("<pre class=\"brush: " + 
                        getLanguageFromExtension(src_file) +
                         "\">" + content + "</pre>");
                    load_callback();
                }, "text");
            }
            // IF IT'S IN CODE	
            else {
                $.get(folder + "code/" + src_file, function(data) {
                    content = data;
                    el.after("<pre class=\"brush: " + 
                        getLanguageFromExtension(src_file) +
                         "\">" + content + "</pre>");
                    load_callback();
                },"text");
            }
            // OR HAS JUST TO BE HIGHLIGHTED
        } else {
            var lang = el.attr("lang");
            el.after("<pre class=\"brush: " + lang + "\">" + el.html() + "</pre>");
        }
    });
}

function getLanguageFromExtension(fileName) {
    var extension = fileName.substring(fileName.lastIndexOf(".") + 1);
    if (ext_to_lang_hash.ext[extension] && ext_to_lang_hash.ext[extension].lang) {
        return ext_to_lang_hash.ext[extension].lang
    } else {
        return "jolie"
    }
}

function openTopic(jqTree, content_path) {
    var jT = jqTree.tree('toJson');
    var nodeId = findNodeByURL(jT, content_path);
    jqTree.tree("selectNode", jqTree.tree("getNodeById", nodeId), true);

}

function findNodeByURL(json, url) {
    var id = "";
    $.each(json, function(ti, topic) {
        $.each(topic.children, function(ni, node) {
            if (node.url == url) {
                id = node.id;
                return false;
            }
        });
        if (id != "") {
            return false
        }
    });
    return id;
}

function TOCCreator(create) {
    if (create) {
        var tn = 0;
        var titles = $("#doc_content h2");
        var title_list = "<div class='grid_9 dropdown'>" + "<div class='dropdowntitle'>Table of Contents</div>";
        title_list += "<div class='grid_9 submenu'><ul class='root'>";
        $.each(titles, function(key, title) {
            title_list += "<li onclick='TOC_scroll(  " + (tn++) + "  );'>" + $(title).text() + "</li>"
        });
        title_list += "</ul></div></div><div class=\"grid_10 push_1 to_top\"" + " onclick='$(  \"#doc_content\"  ).nanoScroller(  { scroll:\"top\"}  );' class='grid_5'>" + unescape("%u21E7") + " Return to Top " + unescape("%u21E7") + "</div>";
        $("#TOC_menu").html(title_list);
    } else {
        $("#TOC_menu").html("");
    }
    TOC_events();
}

function TOC_scroll(ei) {
    $("#doc_content").nanoScroller({
        scroll: 'top'
    });
    $("#doc_content").nanoScroller({
        scrollTo: $($("h2")[ei])
    });
}

function TOC_events() {
    $(".dropdowntitle, .submenu").click(function() {
        if ($(".dropdown").css("border-bottom-width") == "1px") {
            $(".dropdown").css("border-bottom-width", "0px");
        } else {
            $(".dropdown").css("border-bottom-width", "1px")
        }
        $(".submenu").slideToggle();
    });
    $(".submenu").mouseleave(function() {
        $(".dropdown").css("border-bottom-width", "1px");
        $(".submenu").slideUp();
    });
}

function side_menu(page, content) {
    History.pushState("", "", "?top_menu=" + page + "&side_menu=" + content);
}

// COMMUNITY FUNCTIONS

function load_community_content(element, page_title) {
    $("#community_side_menu li").removeAttr("id");
    $(element).attr("id", "active");
    load_generic_content("community/" + page_title + ".html", "#community_content");
}

// ABOUT JOLIE FUNCTIONS

function load_about_jolie_content(element, page_title) {
    $("#about_jolie_side_menu li").removeAttr("id");
    $(element).attr("id", "active");
    load_generic_content("about_jolie/" + page_title + ".html", "#about_jolie_content");
}