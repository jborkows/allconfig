(
 (command
   name: (command_name (word) @name)
   argument: (string (string_content) @injection.content) 
   (#set! injection.language "bash")
   )
 (#match? @name "evalFunction")
)
