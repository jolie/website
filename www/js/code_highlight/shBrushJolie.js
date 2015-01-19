SyntaxHighlighter.brushes.Jolie = function()
{
  var funcs       = 'is_defined undef';
  var keywords    = 'include main outputPort inputPort '+
		 					'Location Protocol RequestResponse throw '+
		 					'OneWay interface any long type void sequential raw scope forward '+
		 					'install execution single concurrent Interfaces cset csets double global linkIn '+
		 					'linkOut string bool int synchronized courier extender throws this new '+
		 					'Interfaces nullprocess Redirects embedded extender Aggregates '+
		 					'spawn constants with foreach instanceof <- over define undef is_defined';
 						//  \; \| \<\- \^ over
  this.regexList = [
			{ regex: SyntaxHighlighter.regexLib.singleLineCComments,	css: 'comments' },		// one line comments
			{ regex: /\/\*(.|[\r\n])*?\*\//gm,						css: 'comments' },	 	// multiline comments
			{ regex: /\/\*(?!\*\/)\*[\s\S]*?\*\//gm,					css: 'preprocessor' },	// documentation comments
			{ regex: SyntaxHighlighter.regexLib.doubleQuotedString,		css: 'string' },		// strings
			{ regex: SyntaxHighlighter.regexLib.singleQuotedString,		css: 'string' },		// strings
			{ regex: /\b([\d]+(\.[\d]+)?|0x[a-f0-9]+)\b/gi,				css: 'value' },			// numbers
			{ regex: /(?!\@interface\b)\@[\$\w]+\b/g,					css: 'color1' },		// annotation @anno
			{ regex: /\@interface\b/g,									css: 'color2' },		// @interface keyword
			{ regex: new RegExp(this.getKeywords(keywords), 'gm'),		css: 'keyword' }		// java keyword
			];

	this.forHtmlScript({
		left	: /(&lt;|<)%[@!=]?/g, 
		right	: /%(&gt;|>)/g 
	});
};

SyntaxHighlighter.brushes.Jolie.prototype = new SyntaxHighlighter.Highlighter();
SyntaxHighlighter.brushes.Jolie.aliases  = ['jolie'];
