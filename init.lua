-- ===============================
-- Options
-- ===============================
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.number = true           -- Always show line numbers
vim.opt.relativenumber = false  -- Disable relative line numbers
vim.opt.colorcolumn = "80,120"  -- Vertical rulers
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.foldcolumn = "1"        -- Add a bit extra margin to the left
vim.opt.ruler = true            -- Always show current position
vim.opt.showmatch = true        -- Show matching brackets when text indicator is over them
vim.opt.incsearch = true        -- Makes search act like search in modern browsers
vim.opt.magic = true            -- For regular expressions turn magic on
vim.opt.lazyredraw = true       -- Don't redraw while executing macros (good performance config)
vim.opt.eol = true              -- Append line at the end of file
vim.opt.so = 7                  -- Scroll offset when moving vertically
vim.opt.ttimeoutlen = 10        -- Reduce delay after pressing Esc in insert mode

-- Display warning/error messages inline
vim.diagnostic.config({ virtual_text = true })

-- Filetype-specific indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "html", "css", "javascript", "typescript", "lua", "yaml", "json" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- ===============================
-- Lazy.nvim Plugins
-- ===============================
require("plugins")

-- ===============================
-- LSP Setup
-- ===============================
require("completion")

-- ===============================
-- Custom commands
-- ===============================
require("commands")

-- ===============================
-- Auto commands
-- ===============================
require("auto_commands")

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

