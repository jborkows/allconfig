local function initializeAnsible()
	local ansibleClient = vim.fn.stdpath("data") .. "/mason/bin/ansible-language-server"
	print(ansibleClient)

	local client = vim.lsp.start_client({
		cmd = { ansibleClient, "--stdio" },
		name = "ansible",
		on_attach = require("custom.lspFun").attach,
		capabilities = vim.lsp.protocol.make_client_capabilities(),
	})

	if not client then
		print("Failed to start client")
		return
	end
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("ansible-lsp-info", { clear = true }),
		pattern = { "yml", "yaml" },
		callback = function()
			vim.cmd.LspStop()
			vim.lsp.buf_attach_client(0, client)
		end,
	})
end

vim.schedule(initializeAnsible)
