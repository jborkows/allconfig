#!/usr/bin/env bash
rm -rf tree-sitter-bash || true
git clone --depth=1 https://github.com/tree-sitter/tree-sitter-bash tree-sitter-bash
(cd tree-sitter-bash
npm install

line_to_replace=$(grep -wn raw_string: grammar.js | cut -d: -f1)
sed -i "${line_to_replace}d" grammar.js
sed -i "${line_to_replace}istring_raw_content: \$ => /[^']+/,\n raw_string: \$ => seq(\n  \"'\",\n  field(\"content\", repeat(\$.string_raw_content)),\n  \"'\"\n)," grammar.js

npx tree-sitter generate
sed -i 's|\*tree_sitter_bash(void)|*tree_sitter_bashx(void)|' src/parser.c
gcc -shared -o bashx.so src/parser.c -fPIC
mv bashx.so ~/.local/share/nvim/lazy/nvim-treesitter/parser/
)

nvim -c "TSInstall bashx --with-all --force | quit"
