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
  pattern = {
    "c",
    "html",
    "css",
    "sass",
    "less",
    "javascript",
    "typescript",
    "lua",
    "yaml",
    "json",
    "bash",
    "zsh",
  },
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
-- Custom commands
-- ===============================
require("commands")

-- ===============================
-- Auto commands
-- ===============================
require("auto_commands")

-- ===============================
-- Key bindings
-- ===============================
require("keybindings")
