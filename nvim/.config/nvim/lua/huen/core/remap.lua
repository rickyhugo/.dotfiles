local keymap = vim.keymap.set

-- open vim file explorer
keymap("n", "<leader>pv", vim.cmd.Ex)

-- move selected block of code
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in place when "J"
keymap("n", "J", "mzJ`z")

-- keep cursor centered u/d navigation
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- keep searched word centered when navigating
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- persist yanked buffer after select + paste
keymap("x", "<leader>p", '"_dP')
keymap("n", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')

--yank to system clipboard (paste with <C-v>)
keymap("n", "<leader>y", '"+y')
keymap("v", "<leader>y", '"+y')
keymap("n", "<leader>Y", '"+Y')

-- disable "Q"
keymap("n", "Q", "<nop>")

-- disable recording until i learn it
keymap("n", "q", "<nop>")

--open directory via tmux
-- keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- quickfix
-- keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
-- keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
-- keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
-- keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

-- edit all occurrences of the word under cursor
keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- edit all occurences of selected text
keymap("v", "<C-r>", [["hy:%s/<C-r>h//g<left><left><left>]])

-- make bash script executable
keymap("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true })

-- write shortcut
keymap("n", "<leader>w", ":w<CR>")

-- format shortcut
keymap("n", "<leader>bf", vim.lsp.buf.format)

-- navigate panes
keymap("n", "<M-h>", "<C-w>h")
keymap("n", "<M-j>", "<C-w>j")
keymap("n", "<M-k>", "<C-w>k")
keymap("n", "<M-l>", "<C-w>l")

-- snake case navigation
keymap("n", ",b", "F_")
keymap("n", ",e", "f_")

-- delete buffer
keymap("n", "<leader>bd", "<cmd>bd<CR>")

-- resize buffer
keymap("n", "<C-h>", "10<C-w>>")
keymap("n", "<C-j>", "10<C-w>+")
keymap("n", "<C-k>", "10<C-w>-")
keymap("n", "<C-l>", "10<C-w><")
