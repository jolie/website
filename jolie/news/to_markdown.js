/* importClass( java.lang.System ); */

/*! http://mths.be/he v<%= version %> by @mathias | MIT license */
(function (root) {

  // Detect free variables `exports`.
  var freeExports = typeof exports === 'object' && exports;

  // Detect free variable `module`.
  var freeModule = typeof module === 'object' && module &&
    module.exports === freeExports && module;

  // Detect free variable `global`, from Node.js or Browserified code,
  // and use it as `root`.
  var freeGlobal = typeof global === 'object' && global;
  if (freeGlobal.global === freeGlobal || freeGlobal.window === freeGlobal) {
    root = freeGlobal;
  }

  /*--------------------------------------------------------------------------*/

  // All astral symbols.
  var regexAstralSymbols = /<%= regexAstralSymbol %>/g;
  // All ASCII symbols (not just printable ASCII) except those listed in the
  // first column of the overrides table.
  // http://whatwg.org/html/tokenization.html#table-charref-overrides
  var regexAsciiWhitelist = /<%= regexAsciiWhitelist %>/g;
  // All BMP symbols that are not ASCII newlines, printable ASCII symbols, or
  // code points listed in the first column of the overrides table on
  // http://whatwg.org/html/tokenization.html#table-charref-overrides.
  var regexBmpWhitelist = /<%= regexBmpWhitelist %>/g;

  var regexEncodeNonAscii = /<%= regexEncodeNonAscii %>/g;
  var encodeMap = /<%= encodeMap %>/;

  var regexEscape = /["&'<>`]/g;
  var escapeMap = {
    "\""  : "&quot;",
    "&"   : "&amp;",
    "\\"  :  "&#x27;",
    "<"   :  "&lt;",
    // See https://mathiasbynens.be/notes/ambiguous-ampersands: in HTML, the
    // following is not strictly necessary unless it’s part of a tag or an
    // unquoted attribute value. We’re only escaping it to support those
    // situations, and for XML support.
    ">": "&gt;",
    // In Internet Explorer ≤ 8, the backtick character can be used
    // to break out of (un)quoted attribute values or HTML comments.
    // See http://html5sec.org/#102, http://html5sec.org/#108, and
    // http://html5sec.org/#133.
    "`": "&#x60;"
  };

  var regexInvalidEntity = /&#(?:[xX][^a-fA-F0-9]|[^0-9xX])/;
  var regexInvalidRawCodePoint = /<%= regexInvalidRawCodePoints %>|<%= regexLoneSurrogate %>/;
  var regexDecode = /<%= regexDecimalEscapeSource %>|<%= regexHexadecimalEscapeSource %>|<%= regexNamedReferenceSource %>|<%= regexLegacyReferenceSource %>/g;
  var decodeMap = /<%= decodeMap %>/;
  var decodeMapLegacy = /<%= decodeMapLegacy %>/;
  var decodeMapNumeric = /<%= decodeMapOverrides %>/;
  var invalidReferenceCodePoints = /<%= invalidReferenceCodePoints %>/;

  /*--------------------------------------------------------------------------*/

  var stringFromCharCode = String.fromCharCode;

  var object = {};
  var hasOwnProperty = object.hasOwnProperty;
  var has = function(object, propertyName) {
    return hasOwnProperty.call(object, propertyName);
  };

  var contains = function(array, value) {
    var index = -1;
    var length = array.length;
    while (++index < length) {
      if (array[index] == value) {
        return true;
      }
    }
    return false;
  };

  var merge = function(options, defaults) {
    if (!options) {
      return defaults;
    }
    var result = {};
    var key;
    for (key in defaults) {
      // A `hasOwnProperty` check is not needed here, since only recognized
      // option names are used anyway. Any others are ignored.
      result[key] = has(options, key) ? options[key] : defaults[key];
    }
    return result;
  };

  // Modified version of `ucs2encode`; see http://mths.be/punycode.
  var codePointToSymbol = function(codePoint, strict) {
    var output = '';
    if ((codePoint >= 0xD800 && codePoint <= 0xDFFF) || codePoint > 0x10FFFF) {
      // See issue #4:
      // “Otherwise, if the number is in the range 0xD800 to 0xDFFF or is
      // greater than 0x10FFFF, then this is a parse error. Return a U+FFFD
      // REPLACEMENT CHARACTER.”
      if (strict) {
        parseError('character reference outside the permissible Unicode range');
      }
      return '\uFFFD';
    }
    if (has(decodeMapNumeric, codePoint)) {
      if (strict) {
        parseError('disallowed character reference');
      }
      return decodeMapNumeric[codePoint];
    }
    if (strict && contains(invalidReferenceCodePoints, codePoint)) {
      parseError('disallowed character reference');
    }
    if (codePoint > 0xFFFF) {
      codePoint -= 0x10000;
      output += stringFromCharCode(codePoint >>> 10 & 0x3FF | 0xD800);
      codePoint = 0xDC00 | codePoint & 0x3FF;
    }
    output += stringFromCharCode(codePoint);
    return output;
  };

  var hexEscape = function(symbol) {
    return '&#x' + symbol.charCodeAt(0).toString(16).toUpperCase() + ';';
  };

  var parseError = function(message) {
    throw Error('Parse error: ' + message);
  };

  /*--------------------------------------------------------------------------*/

  var encode = function(string, options) {
    options = merge(options, encode.options);
    var strict = options.strict;
    if (strict && regexInvalidRawCodePoint.test(string)) {
      parseError('forbidden code point');
    }
    var encodeEverything = options.encodeEverything;
    var useNamedReferences = options.useNamedReferences;
    var allowUnsafeSymbols = options.allowUnsafeSymbols;
    if (encodeEverything) {
      // Encode ASCII symbols.
      string = string.replace(regexAsciiWhitelist, function(symbol) {
        // Use named references if requested & possible.
        if (useNamedReferences && has(encodeMap, symbol)) {
          return '&' + encodeMap[symbol] + ';';
        }
        return hexEscape(symbol);
      });
      // Shorten a few escapes that represent two symbols, of which at least one
      // is within the ASCII range.
      if (useNamedReferences) {
        string = string
          .replace(/&gt;\u20D2/g, '&nvgt;')
          .replace(/&lt;\u20D2/g, '&nvlt;')
          .replace(/&#x66;&#x6A;/g, '&fjlig;');
      }
      // Encode non-ASCII symbols.
      if (useNamedReferences) {
        // Encode non-ASCII symbols that can be replaced with a named reference.
        string = string.replace(regexEncodeNonAscii, function(string) {
          // Note: there is no need to check `has(encodeMap, string)` here.
          return '&' + encodeMap[string] + ';';
        });
      }
      // Note: any remaining non-ASCII symbols are handled outside of the `if`.
    } else if (useNamedReferences) {
      // Apply named character references.
      // Encode `<>"'&` using named character references.
      if (!allowUnsafeSymbols) {
        string = string.replace(regexEscape, function(string) {
          return '&' + encodeMap[string] + ';'; // no need to check `has()` here
        });
      }
      // Shorten escapes that represent two symbols, of which at least one is
      // `<>"'&`.
      string = string
        .replace(/&gt;\u20D2/g, '&nvgt;')
        .replace(/&lt;\u20D2/g, '&nvlt;');
      // Encode non-ASCII symbols that can be replaced with a named reference.
      string = string.replace(regexEncodeNonAscii, function(string) {
        // Note: there is no need to check `has(encodeMap, string)` here.
        return '&' + encodeMap[string] + ';';
      });
    } else if (!allowUnsafeSymbols) {
      // Encode `<>"'&` using hexadecimal escapes, now that they’re not handled
      // using named character references.
      string = string.replace(regexEscape, hexEscape);
    }
    return string
      // Encode astral symbols.
      .replace(regexAstralSymbols, function($0) {
        // https://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
        var high = $0.charCodeAt(0);
        var low = $0.charCodeAt(1);
        var codePoint = (high - 0xD800) * 0x400 + low - 0xDC00 + 0x10000;
        return '&#x' + codePoint.toString(16).toUpperCase() + ';';
      })
      // Encode any remaining BMP symbols that are not printable ASCII symbols
      // using a hexadecimal escape.
      .replace(regexBmpWhitelist, hexEscape);
  };
  // Expose default options (so they can be overridden globally).
  encode.options = {
    'allowUnsafeSymbols': false,
    'encodeEverything': false,
    'strict': false,
    'useNamedReferences': false
  };

  var decode = function(html, options) {
    options = merge(options, decode.options);
    var strict = options.strict;
    if (strict && regexInvalidEntity.test(html)) {
      parseError('malformed character reference');
    }
    return html.replace(regexDecode, function($0, $1, $2, $3, $4, $5, $6, $7) {
      var codePoint;
      var semicolon;
      var hexDigits;
      var reference;
      var next;
      if ($1) {
        // Decode decimal escapes, e.g. `&#119558;`.
        codePoint = $1;
        semicolon = $2;
        if (strict && !semicolon) {
          parseError('character reference was not terminated by a semicolon');
        }
        return codePointToSymbol(codePoint, strict);
      }
      if ($3) {
        // Decode hexadecimal escapes, e.g. `&#x1D306;`.
        hexDigits = $3;
        semicolon = $4;
        if (strict && !semicolon) {
          parseError('character reference was not terminated by a semicolon');
        }
        codePoint = parseInt(hexDigits, 16);
        return codePointToSymbol(codePoint, strict);
      }
      if ($5) {
        // Decode named character references with trailing `;`, e.g. `&copy;`.
        reference = $5;
        if (has(decodeMap, reference)) {
          return decodeMap[reference];
        } else {
          // Ambiguous ampersand; see http://mths.be/notes/ambiguous-ampersands.
          if (strict) {
            parseError(
              'named character reference was not terminated by a semicolon'
            );
          }
          return $0;
        }
      }
      // If we’re still here, it’s a legacy reference for sure. No need for an
      // extra `if` check.
      // Decode named character references without trailing `;`, e.g. `&amp`
      // This is only a parse error if it gets converted to `&`, or if it is
      // followed by `=` in an attribute context.
      reference = $6;
      next = $7;
      if (next && options.isAttributeValue) {
        if (strict && next == '=') {
          parseError('`&` did not start a character reference');
        }
        return $0;
      } else {
        if (strict) {
          parseError(
            'named character reference was not terminated by a semicolon'
          );
        }
        // Note: there is no need to check `has(decodeMapLegacy, reference)`.
        return decodeMapLegacy[reference] + (next || '');
      }
    });
  };
  // Expose default options (so they can be overridden globally).
  decode.options = {
    'isAttributeValue': false,
    'strict': false
  };

  var escape = function(string) {
    return string.replace(regexEscape, function($0) {
      // Note: there is no need to check `has(escapeMap, $0)` here.
      return escapeMap[$0];
    });
  };

  /*--------------------------------------------------------------------------*/

  var he = {
    'version': '<%= version %>',
    'encode': encode,
    'decode': decode,
    'escape': escape,
    'unescape': decode
  };

  // Some AMD build optimizers, like r.js, check for specific condition patterns
  // like the following:
  if (
    typeof define == 'function' &&
    typeof define.amd == 'object' &&
    define.amd
  ) {
    define(function() {
      return he;
    });
  } else if (freeExports && !freeExports.nodeType) {
    if (freeModule) { // in Node.js or RingoJS v0.8.0+
      freeModule.exports = he;
    } else { // in Narwhal or RingoJS v0.7.0-
      for (var key in he) {
        has(he, key) && (freeExports[key] = he[key]);
      }
    }
  } else { // in Rhino or a web browser
    root.he = he;
  }

}(this));

/*
 * to-markdown - an HTML to Markdown converter
 *
 * Copyright 2011, Dom Christie
 * Licenced under the MIT licence
 *
 */

if (typeof he !== 'object' && typeof require === 'function') {
  var he = require('he');
}


function convertToMarkdown( src ) {
  var src = String( new java.lang.String(src.getFirstChild("text").strValue()) );
  return toMarkdown( src );
}

var toMarkdown = function(string) {

  var ELEMENTS = [
    {
      patterns: 'p',
      replacement: function(str, attrs, innerHTML) {
        return innerHTML ? '\n\n' + innerHTML + '\n' : '';
      }
    },
    {
      patterns: 'br',
      type: 'void',
      replacement: '\n'
    },
    {
      patterns: 'h([1-6])',
      replacement: function(str, hLevel, attrs, innerHTML) {
        var hPrefix = '';
        for(var i = 0; i < hLevel; i++) {
          hPrefix += '#';
        }
        return '\n\n' + hPrefix + ' ' + innerHTML + '\n';
      }
    },
    {
      patterns: 'hr',
      type: 'void',
      replacement: '\n\n* * *\n'
    },
    {
      patterns: 'a',
      replacement: function(str, attrs, innerHTML) {
        var href = attrs.match(attrRegExp('href')),
            title = attrs.match(attrRegExp('title'));
        return href ? '[' + innerHTML + ']' + '(' + href[1] + (title && title[1] ? ' "' + title[1] + '"' : '') + ')' : str;
      }
    },
    {
      patterns: ['b', 'strong'],
      replacement: function(str, attrs, innerHTML) {
        return innerHTML ? '**' + innerHTML + '**' : '';
      }
    },
    {
      patterns: ['i', 'em'],
      replacement: function(str, attrs, innerHTML) {
        return innerHTML ? '_' + innerHTML + '_' : '';
      }
    },
    {
      patterns: 'code',
      replacement: function(str, attrs, innerHTML) {
        return innerHTML ? '`' + he.decode(innerHTML) + '`' : '';
      }
    },
    {
      patterns: 'img',
      type: 'void',
      replacement: function(str, attrs, innerHTML) {
        var src = attrs.match(attrRegExp('src')),
            alt = attrs.match(attrRegExp('alt')),
            title = attrs.match(attrRegExp('title'));
        return '![' + (alt && alt[1] ? alt[1] : '') + ']' + '(' + src[1] + (title && title[1] ? ' "' + title[1] + '"' : '') + ')';
      }
    }
  ];

  for(var i = 0, len = ELEMENTS.length; i < len; i++) {
    if(typeof ELEMENTS[i].patterns === 'string') {
      string = replaceEls(string, { tag: ELEMENTS[i].patterns, replacement: ELEMENTS[i].replacement, type:  ELEMENTS[i].type });
    }
    else {
      for(var j = 0, pLen = ELEMENTS[i].patterns.length; j < pLen; j++) {
        string = replaceEls(string, { tag: ELEMENTS[i].patterns[j], replacement: ELEMENTS[i].replacement, type:  ELEMENTS[i].type });
      }
    }
  }

  function replaceEls(html, elProperties) {
    var pattern = elProperties.type === 'void' ? '<' + elProperties.tag + '\\b([^>]*)\\/?>' : '<' + elProperties.tag + '\\b([^>]*)>([\\s\\S]*?)<\\/' + elProperties.tag + '>',
        regex = new RegExp(pattern, 'gi'),
        markdown = '';
    if(typeof elProperties.replacement === 'string') {
      markdown = html.replace(regex, elProperties.replacement);
    }
    else {
      markdown = html.replace(regex, function(str, p1, p2, p3) {
        return elProperties.replacement.call(this, str, p1, p2, p3);
      });
    }
    return markdown;
  }

  function attrRegExp(attr) {
    return new RegExp(attr + '\\s*=\\s*["\']?([^"\']*)["\']?', 'i');
  }

  // Pre code blocks

  string = string.replace(/<pre\b[^>]*>`([\s\S]*)`<\/pre>/gi, function(str, innerHTML) {
    var text = he.decode(innerHTML);
    text = text.replace(/^\t+/g, '  '); // convert tabs to spaces (you know it makes sense)
    text = text.replace(/\n/g, '\n    ');
    return '\n\n    ' + text + '\n';
  });

  // Lists

  // Escape numbers that could trigger an ol
  // If there are more than three spaces before the code, it would be in a pre tag
  // Make sure we are escaping the period not matching any character
  string = string.replace(/^(\s{0,3}\d+)\. /g, '$1\\. ');

  // Converts lists that have no child lists (of same type) first, then works its way up
  var noChildrenRegex = /<(ul|ol)\b[^>]*>(?:(?!<ul|<ol)[\s\S])*?<\/\1>/gi;
  while(string.match(noChildrenRegex)) {
    string = string.replace(noChildrenRegex, function(str) {
      return replaceLists(str);
    });
  }

  function replaceLists(html) {

    html = html.replace(/<(ul|ol)\b[^>]*>([\s\S]*?)<\/\1>/gi, function(str, listType, innerHTML) {
      var lis = innerHTML.split('</li>');
      lis.splice(lis.length - 1, 1);

      for(i = 0, len = lis.length; i < len; i++) {
        if(lis[i]) {
          var prefix = (listType === 'ol') ? (i + 1) + ".  " : "*   ";
          lis[i] = lis[i].replace(/\s*<li[^>]*>([\s\S]*)/i, function(str, innerHTML) {

            innerHTML = innerHTML.replace(/^\s+/, '');
            innerHTML = innerHTML.replace(/\n\n/g, '\n\n    ');
            // indent nested lists
            innerHTML = innerHTML.replace(/\n([ ]*)+(\*|\d+\.) /g, '\n$1    $2 ');
            return prefix + innerHTML;
          });
        }
      }
      return lis.join('\n');
    });
    return '\n\n' + html.replace(/[ \t]+\n|\s+$/g, '');
  }

  // Blockquotes
  var deepest = /<blockquote\b[^>]*>((?:(?!<blockquote)[\s\S])*?)<\/blockquote>/gi;
  while(string.match(deepest)) {
    string = string.replace(deepest, function(str) {
      return replaceBlockquotes(str);
    });
  }

  function replaceBlockquotes(html) {
    html = html.replace(/<blockquote\b[^>]*>([\s\S]*?)<\/blockquote>/gi, function(str, inner) {
      inner = inner.replace(/^\s+|\s+$/g, '');
      inner = cleanUp(inner);
      inner = inner.replace(/^/gm, '> ');
      inner = inner.replace(/^(>([ \t]{2,}>)+)/gm, '> >');
      return inner;
    });
    return html;
  }

  function cleanUp(string) {
    string = string.replace(/^[\t\r\n]+|[\t\r\n]+$/g, ''); // trim leading/trailing whitespace
    string = string.replace(/\n\s+\n/g, '\n\n');
    string = string.replace(/\n{3,}/g, '\n\n'); // limit consecutive linebreaks to 2
    return string;
  }

  return cleanUp(string);
};

if (typeof exports === 'object') {
  exports.toMarkdown = toMarkdown;
}