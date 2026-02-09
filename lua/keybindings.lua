-- ===============================
-- Keybindings
-- ===============================

-- Buffer tabs navigation
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Search
vim.keymap.set("n", "<C-h>", "<Cmd>noh<CR>", { desc = "Clear search highlights" })

-- Folding/unfolding
vim.keymap.set("n", "<leader>zo", "<Cmd>foldopen<CR>", { desc = "Open fold" })
vim.keymap.set("n", "<leader>zc", "<Cmd>foldclose<CR>", { desc = "Close fold" })
vim.keymap.set("n", "<leader>zR", "<Cmd>foldtoggle<CR>", { desc = "Toggle fold" })

-- NERDTree
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Session management
vim.keymap.set('n', '<C-s>', function()
  vim.cmd('NERDTreeClose')
  vim.cmd('mksession!')
end, { noremap = true, silent = true })

-- Toggle soft-wrap + linebreak (buffer-local)
vim.keymap.set("n", "<C-b>", function()
  local w = vim.wo.wrap

  if w then
    -- OFF
    vim.wo.wrap = false
    vim.wo.linebreak = false
  else
    -- ON
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end
end, { desc = "Toggle wrap + linebreak" })
