SyntaxHighlighter.brushes.Plain = function()
{
	this.forHtmlScript({
		left	: /(&lt;|<)%[@!=]?/g, 
		right	: /%(&gt;|>)/g
	});
};

SyntaxHighlighter.brushes.Plain.prototype = new SyntaxHighlighter.Highlighter();
SyntaxHighlighter.brushes.Plain.aliases  = ['plain'];
