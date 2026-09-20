-- man: make cross-references clickable like emacs WoMan
-- <CR> and double-click jump to tag (SEE ALSO, socket(2) etc.)
vim.keymap.set("n", "<CR>", "<C-]>", { buffer = true, silent = true, desc = "Man: follow reference" })
vim.keymap.set("n", "<2-LeftMouse>", "<C-]>", { buffer = true, silent = true, desc = "Man: follow reference (click)" })
