vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.t_Co = 256
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

vim.opt.title = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.shell = "zsh"

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.backupskip = "/tmp/*,/private/tmp/*"
vim.opt.inccommand = "split"
vim.opt.ignorecase = true

vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ai = true -- Auto indent
vim.opt.si = true -- Smart indent
vim.opt.smarttab = true

vim.opt.wrap = false -- Wrap lines

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.backspace = "start,eol,indent"
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders

vim.opt.colorcolumn = "80"

vim.opt.updatetime = 50

vim.g.mapleader = " "

vim.g.python3_host_prog = "/home/huen/.local/share/mise/installs/python/3.10/bin/python"

vim.g.loaded_perl_provider = 0

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.py", "*.lua" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

vim.o.shortmess = vim.o.shortmess .. "I" -- Disable intro message

vim.opt.splitright = true -- Vertical split to the right

-- Diagnostic symbols in sign column
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
