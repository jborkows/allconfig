(
(
    (comment) @html
    (#match? @html "# lang:html")
)
(
	(expression_statement
		(assignment
			 right: (string
				(string_content) @injection.content
				(#set! injection.language "html")
			)
		)
	)
	)
)

