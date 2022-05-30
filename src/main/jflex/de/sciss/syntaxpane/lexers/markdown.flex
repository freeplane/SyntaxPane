/*
 * Copyright 2011-2022 Hanns Holger Rutz.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License
 *       at http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// cf. http://spec.commonmark.org

package de.sciss.syntaxpane.lexers;

import de.sciss.syntaxpane.Token;
import de.sciss.syntaxpane.TokenType;

%%

%public
%class MarkdownLexer
%extends DefaultJFlexLexer
%final
%unicode
%char
%type Token

%{
    /**
     * Create an empty lexer, yyrset will be called later to reset and assign
     * the reader
     */
    public MarkdownLexer() {
        super();
    }

    @Override
    public int yychar() {
        return yychar;
    }

    private static final byte TAG_OPEN      =  1;
    private static final byte TAG_CLOSE     = -1;

    private static final byte COMMENT_OPEN  =  4;
    private static final byte COMMENT_CLOSE = -4;
%}

%xstate COMMENT, TAG, ESCAPESTATE, CODESTATE, CHARVALUE

/* markdown */

//nl                  = [\n|\r|\r\n]
//tab                 = [\t\f]

space               = " "
spaceIndent         = {space}{0,3}
spacesOpt           = [ ]*
//nonWhite            = [^ \t\f\r\n]
nonWhiteStar        = [^ \*\t\f\r\n]
nonWhiteUS          = [^ \_\t\f\r\n]

//newstring           = ([\n|\r|\r\n]{3,100})([a-zA-Z0-9.,;:]+)
//string              = [a-zA-Z0-9.,;:]+
//newstar             = ([\n|\r|\r\n]{3,100})(\*)
//star                = \*
//newstarDouble       = ([\n|\r|\r\n]{3,100})(\*\*)
//starDouble			= \*\*
//newunderscore       = ([\n|\r|\r\n]{3,100})(\_)
//underscore          = \_
//newunderscoreDouble = ([\n|\r|\r\n]{3,100})(__)
//underscoreDouble    = __
//squareBracketO      = \[
//squareBracketC      = \]
//roundBracketO       = \(
//roundBracketC       = \)
//equal               = (\=)+
//hash                = #
//rowSpaces           = [" "]{1,3}
//startOrdList        = [" "]{1,3}[0-9]+.[" "]*
//startUnList         = [" "]{1,3}(\*|\+|\-)((" ")+| \t)
//startPre            = [" "]{4}
//id                  = [A-Za-z_][A-Za-z0-9_]*
//IntegerNumber       = 0 | [1-9][0-9]*
//charValue           = [a-zA-Z]
//FloatLiteral        = ({FLit1}|{FLit2}|{FLit3}) {Exponent}?
//FLit1               = [0-9]+ \. [0-9]*
//FLit2               = \. [0-9]+
//FLit3               = [0-9]+
//Exponent            = [eE] [+-]? [0-9]+

/* embedded HTML */

/* white space */
S = (\u0020 | \u0009 | \u000D | \u000A)+

/* characters */
// Char = \u0009 | \u000A | \u000D | [\u0020-\uD7FF] | [\uE000-\uFFFD] | [\u10000-\u10FFFF]

/* comments */
CommentStart = "<!--"
CommentEnd = "-->"

NameStartChar = ":" | [A-Z] | "_" | [a-z]
NameChar = {NameStartChar} | "-" | "." | [0-9] | \u00B7
Name = {NameStartChar} {NameChar}*

/* Tags */
OpenTagStart = "<" {Name}
OpenTagClose = "/>"
OpenTagEnd = ">"
CloseTag = "</" {Name} {S}* ">"

/* attribute */
Attribute = {Name} "="

/* HTML specifics */
HTMLTagName =
    "address"        |
    "applet"         |
    "area"           |
    "a"              |
    "b"              |
    "base"           |
    "basefont"       |
    "big"            |
    "blockquote"     |
    "body"           |
    "br"             |
    "caption"        |
    "center"         |
    "cite"           |
    "code"           |
    "dd"             |
    "dfn"            |
    "dir"            |
    "div"            |
    "dl"             |
    "dt"             |
    "font"           |
    "form"           |
    "h"[1-6]         |
    "head"           |
    "hr"             |
    "html"           |
    "img"            |
    "input"          |
    "isindex"        |
    "kbd"            |
    "li"             |
    "link"           |
    "LINK"           |
    "map"            |
    "META"           |
    "menu"           |
    "meta"           |
    "ol"             |
    "option"         |
    "param"          |
    "pre"            |
    "p"              |
    "samp"           |
    "span"           |
    "select"         |
    "small"          |
    "strike"         |
    "sub"            |
    "sup"            |
    "table"          |
    "td"             |
    "textarea"       |
    "th"             |
    "title"          |
    "tr"             |
    "tt"             |
    "ul"             |
    "var"            |
    "xmp"            |
    "script"         |
    "noscript"       |
    "style"

HTMLAttrName =
    "action"            |
    "align"             |
    "alink"             |
    "alt"               |
    "archive"           |
    "background"        |
    "bgcolor"           |
    "border"            |
    "bordercolor"       |
    "cellpadding"       |
    "cellspacing"       |
    "checked"           |
    "class"             |
    "clear"             |
    "code"              |
    "codebase"          |
    "color"             |
    "cols"              |
    "colspan"           |
    "content"           |
    "coords"            |
    "enctype"           |
    "face"              |
    "gutter"            |
    "height"            |
    "hspace"            |
    "href"              |
    "id"                |
    "link"              |
    "lowsrc"            |
    "marginheight"      |
    "marginwidth"       |
    "maxlength"         |
    "method"            |
    "name"              |
    "prompt"            |
    "rel"               |
    "rev"               |
    "rows"              |
    "rowspan"           |
    "scrolling"         |
    "selected"          |
    "shape"             |
    "size"              |
    "src"               |
    "start"             |
    "target"            |
    "text"              |
    "type"              |
    "url"               |
    "usemap"            |
    "ismap"             |
    "valign"            |
    "value"             |
    "vlink"             |
    "vspace"            |
    "width"             |
    "wrap"              |
    "abbr"              |
    "accept"            |
    "accesskey"         |
    "axis"              |
    "char"              |
    "charoff"           |
    "charset"           |
    "cite"              |
    "classid"           |
    "codetype"          |
    "compact"           |
    "data"              |
    "datetime"          |
    "declare"           |
    "defer"             |
    "dir"               |
    "disabled"          |
    "for"               |
    "frame"             |
    "headers"           |
    "hreflang"          |
    "lang"              |
    "language"          |
    "longdesc"          |
    "multiple"          |
    "nohref"            |
    "nowrap"            |
    "object"            |
    "profile"           |
    "readonly"          |
    "rules"             |
    "scheme"            |
    "scope"             |
    "span"              |
    "standby"           |
    "style"             |
    "summary"           |
    "tabindex"          |
    "valuetype"         |
    "version"

HTMLOpenTagStart = "<" {HTMLTagName}
HTMLCloseTag = "</" {HTMLTagName} {S}* ">"
HTMLAttribute = {HTMLAttrName} "="

/* string and character literals */
DQuoteStringChar = [^\r\n\"]
SQuoteStringChar = [^\r\n\']

%%

<YYINITIAL> {

/*
    4.2 ATX headings

    An ATX heading consists of a string of characters, parsed as inline content, between an opening
    sequence of 1–6 unescaped `#` characters and an optional closing sequence of any number of unescaped
    `#` characters. The opening sequence of `#` characters must be followed by a space or by the end of
    line. The optional closing sequence of `#`s must be preceded by a space and may be followed by spaces
    only. The opening `#` character may be indented 0-3 spaces. The raw contents of the heading are
    stripped of leading and trailing spaces before being parsed as inline content. The heading level is
    equal to the number of `#` characters in the opening sequence.

*/

    ^{spaceIndent} "#"{1,6} ({space}~\n|\n) { return token(TokenType.KEYWORD2); }

/*
    4.3 Setext headings

    A setext heading consists of one or more lines of text, each containing at least one non-whitespace
    character, with no more than 3 spaces indentation, followed by a setext heading underline. The lines
    of text must be such that, were they not followed by the setext heading underline, they would be
    interpreted as a paragraph: they cannot be interpretable as a code fence, ATX heading, block quote,
    thematic break, list item, or HTML block.

    A setext heading underline is a sequence of `=` characters or a sequence of `-` characters, with no
    more than 3 spaces indentation and any number of trailing spaces. If a line containing a single `-`
    can be interpreted as an empty list items, it should be interpreted this way and not as a setext
    heading underline.

    The heading is a level 1 heading if `=` characters are used in the setext heading underline, and a
    level 2 heading if `-` characters are used. The contents of the heading are the result of parsing
    the preceding lines of text as CommonMark inline content.

    In general, a setext heading need not be preceded or followed by a blank line. However, it cannot
    interrupt a paragraph, so when a setext heading comes after a paragraph, a blank line is needed
    between them.

    XXX TODO

 */

 /*

    4.4 Indented code blocks

    An indented code block is composed of one or more indented chunks separated by blank lines. An indented
    chunk is a sequence of non-blank lines, each indented four or more spaces. The contents of the code
    block are the literal contents of the lines, including trailing line endings, minus four spaces of
    indentation. An indented code block has no info string.

    An indented code block cannot interrupt a paragraph, so there must be a blank line between a paragraph
    and a following indented code block. (A blank line is not needed, however, between a code block and a
    following paragraph.)

    XXX TODO

  */

  ^{space}*\n({space}{4,4} ~ \n)+{space}*\n { return token(TokenType.STRING); }

/*
    4.1 Thematic breaks

    A line consisting of 0-3 spaces of indentation, followed by a sequence of three or more
    matching -, _, or * characters, each followed optionally by any number of spaces,
    forms a thematic break.

 */

  ^{spaceIndent}(\-{spacesOpt}\-{spacesOpt}(\-{spacesOpt})+ | \*{spacesOpt}\*{spacesOpt}(\*{spacesOpt})+ | \_{spacesOpt}\_{spacesOpt}(\_{spacesOpt})+)\n { return token(TokenType.DELIMITER); }

/*
    4.7 Link reference definitions

    XXX TODO

 */

  \[ ~ \] \( ~ \) { return token(TokenType.KEYWORD); }

/*
    5.1 Block quotes

    A block quote marker consists of 0-3 spaces of initial indent, plus (a) the character `>` together with
    a following space, or (b) a single character `>` not followed by a space.

    The following rules define block quotes:

    1. Basic case. If a string of lines __Ls__ constitute a sequence of blocks __Bs__, then the result of prepending
       a block quote marker to the beginning of each line in __Ls__ is a block quote containing __Bs__.

    2. Laziness. If a string of lines __Ls__ constitute a block quote with contents __Bs__, then the result of
       deleting the initial block quote marker from one or more lines in which the next non-whitespace
       character after the block quote marker is paragraph continuation text is a block quote with __Bs__ as
       its content. Paragraph continuation text is text that will be parsed as part of the content of a
       paragraph, but does not occur at the beginning of the paragraph.

    3. Consecutiveness. A document cannot contain two block quotes in a row unless there is a blank line
       between them.

    Nothing else counts as a block quote.

    XXX TODO

 */

  ^{spaceIndent} (">" {space} | ">\n") { return token(TokenType.DELIMITER); }

/*
    5.2 List items

    XXX TODO

 */

/*

    5.3 Lists

    XXX TODO

 */

  ^{spaceIndent}[\-\+\*]{space}         { return token(TokenType.DELIMITER); }

  ^{spaceIndent}[0-9]{1,9}[\.\)]{space} { return token(TokenType.DELIMITER); }

/*

    6.1 Backslash escapes

    XXX TODO

 */

/*

    6.2 Entity and numeric character references

    XXX TODO

 */

/*

    6.3 Code spans

    A backtick string is a string of one or more backtick characters (<code>`</code>) that is neither preceded
    nor followed by a backtick.

    A code span begins with a backtick string and ends with a backtick string of equal length. The contents
    of the code span are the characters between the two backtick strings, with leading and trailing spaces
    and line endings removed, and whitespace collapsed to single spaces.

    XXX TODO: we only implement simple check for single matching backticks

 */

  "`" ~ "`" { return token(TokenType.STRING); }

/*

    6.4 Emphasis and strong emphasis

    XXX TODO - the spec is horrible

 */

  "**" (({nonWhiteStar} "**") | ({nonWhiteStar} ~ ({nonWhiteStar} "**"))) { return token(TokenType.TYPE2); }
  "__" (({nonWhiteUS  } "__") | ({nonWhiteUS}   ~ ({nonWhiteUS}   "__"))) { return token(TokenType.TYPE2); }

  "*"  (({nonWhiteStar} "*" ) | ({nonWhiteStar} ~ ({nonWhiteStar} "*" ))) { return token(TokenType.TYPE3); }
  "_"  (({nonWhiteUS}   "_" ) | ({nonWhiteUS}   ~ ({nonWhiteUS}   "_" ))) { return token(TokenType.TYPE3); }

/*

    6.5 Links

    XXX TODO

 */

/*

    6.6 Images

    XXX TODO

 */

/*
    6.7 Autolinks

    XXX TODO

 */

/*

    6.8 Raw HTML

    XXX TODO

 */

/*
    6.9 Hard line breaks

    XXX TODO

 */

/* HTML support */

  "&"  [a-z]+ ";"                |
  "&#" [:digit:]+ ";"            { return token(TokenType.KEYWORD2); }

  {HTMLOpenTagStart}             {
                                     yybegin(TAG);
                                     return token(TokenType.KEYWORD2, TAG_OPEN);
                                 }
  {HTMLCloseTag}                 {   return token(TokenType.KEYWORD2, TAG_CLOSE); }
  {OpenTagStart}                 {
                                     yybegin(TAG);
                                     return token(TokenType.KEYWORD, TAG_OPEN);
                                 }
  {CloseTag}                     {   return token(TokenType.KEYWORD, TAG_CLOSE); }
  {CommentStart}                 {
                                     yybegin(COMMENT);
                                     return token(TokenType.COMMENT2, COMMENT_OPEN);
                                 }
}

<TAG> {
  {HTMLAttribute}                { return token(TokenType.KEYWORD2); }
  {Attribute}                    { return token(TokenType.IDENTIFIER); }

  \"{DQuoteStringChar}*\"        |
  \'{SQuoteStringChar}*\'        { return token(TokenType.STRING); }


  {OpenTagClose}                 {
                                     yybegin(YYINITIAL);
                                     return token(TokenType.KEYWORD, TAG_CLOSE);
}

  {OpenTagEnd}                   {
                                     yybegin(YYINITIAL);
                                     return token(TokenType.KEYWORD);
                                 }
}

<COMMENT> {
  {CommentEnd}                   {
                                     yybegin(YYINITIAL);
                                     return token(TokenType.COMMENT2, COMMENT_CLOSE);
                                 }
   ~{CommentEnd}                 {
                                     yypushback(3);
                                     return token(TokenType.COMMENT);
                                 }
}

<YYINITIAL,TAG,COMMENT> {
/* error fallback */
   .|\n                          {  }
   <<EOF>>                       { return null; }
}