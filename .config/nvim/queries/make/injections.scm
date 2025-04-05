(
  (recipe_line
    (shell_text) @python)
  (#match? @python "^python3 -c \"")
  (#set! injection.language "python")
  (#set! injection.include-quoted)
  (#offset! @python 12 0 -1 0)
)

