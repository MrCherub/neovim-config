; Compatibility override for Neovim 0.11.6 + current latex parser.
; The upstream nvim-treesitter latex highlights query references newer node
; types that this parser does not expose yet, so keep a smaller supported set.

; General syntax
(command_name) @function @nospell

(caption
  command: _ @function)

; Turn spelling on for text
(text) @spell

; \text, \intertext, \shortintertext, ...
(text_mode
  command: _ @function @nospell
  content: (curly_group
    (_) @none @spell))

; Variables, parameters
(placeholder) @variable

(key_value_pair
  key: (_) @variable.parameter @nospell
  value: (_))

(curly_group_spec
  (text) @variable.parameter)

(brack_group_argc) @variable.parameter

[
  (operator)
  "="
  "_"
  "^"
] @operator

"\\item" @punctuation.special

(delimiter) @punctuation.delimiter

(math_delimiter
  left_command: _ @punctuation.delimiter
  left_delimiter: _ @punctuation.delimiter
  right_command: _ @punctuation.delimiter
  right_delimiter: _ @punctuation.delimiter)

[
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; General environments
(begin
  command: _ @module
  name: (curly_group_text
    (text) @label @nospell))

(end
  command: _ @module
  name: (curly_group_text
    (text) @label @nospell))

; Definitions and references
(new_command_definition
  command: _ @function.macro @nospell)

(old_command_definition
  command: _ @function.macro @nospell)

(let_command_definition
  command: _ @function.macro @nospell)

(environment_definition
  command: _ @function.macro @nospell
  name: (curly_group_text
    (_) @label @nospell))

(theorem_definition
  command: _ @function.macro @nospell
  name: (curly_group_text_list
    (_) @label @nospell))

(paired_delimiter_definition
  command: _ @function.macro @nospell
  declaration: (curly_group_command_name
    (_) @function))

(citation
  command: _ @function.macro @nospell
  keys: (curly_group_text_list) @markup.link @nospell)

((hyperlink
  command: _ @function @nospell
  uri: (curly_group_uri
    (_) @markup.link.url @nospell)) @_hyperlink
  (#set! @_hyperlink url @markup.link.url))

(glossary_entry_definition
  command: _ @function.macro @nospell
  name: (curly_group_text
    (_) @markup.link @nospell))

(glossary_entry_reference
  command: _ @function.macro
  name: (curly_group_text
    (_) @markup.link))

(acronym_definition
  command: _ @function.macro @nospell
  short: (curly_group
    (_) @markup.link @nospell))

(acronym_reference
  command: _ @function.macro @nospell
  name: (curly_group_text
    (_) @markup.link @nospell))

(color_definition
  command: _ @function.macro @nospell
  name: (curly_group_text
    (_) @label @nospell))

(color_reference
  command: _ @function.macro @nospell
  name: (curly_group_text
    (_) @label @nospell))

; Metadata and document structure
(title_declaration
  command: _ @keyword
  text: (curly_group
    (_) @markup.heading))

(author_declaration
  command: _ @keyword)

(author
  (text) @markup.strong)

[
  (chapter)
  (part)
  (section)
  (subsection)
  (subsubsection)
  (paragraph)
  (subparagraph)
] @markup.heading

; Generic commands and environments
(generic_environment
  begin: (begin
    command: _ @module)
  end: (end
    command: _ @module))

(generic_command
  command: _ @function)

; Includes and imports
[
  (class_include)
  (package_include)
  (latex_include)
  (verbatim_include)
  (import_include)
  (bibstyle_include)
  (bibtex_include)
  (biblatex_include)
  (graphics_include)
  (svg_include)
  (inkscape_include)
] @string.special.path

(tikz_library_import
  command: _ @function.macro @nospell)

; Math
[
  (displayed_equation)
  (inline_formula)
  (math_environment)
] @markup.math

; Comments
[
  (line_comment)
  (block_comment)
  (comment_environment)
] @comment
