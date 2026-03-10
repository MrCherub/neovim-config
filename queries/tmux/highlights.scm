(comment) @comment @spell

[
  (string)
  (raw_string)
] @string

(path) @string.special.path
(int) @number

[
  (option)
  (name)
] @variable

(command_line_option) @variable.builtin
(command) @keyword

(source_file_directive
  (command) @keyword.import)

(attribute) @attribute
(function_name) @function.call
