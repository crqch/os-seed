require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "svelte", "emmet_language_server", "tailwindcss", "ts_ls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
