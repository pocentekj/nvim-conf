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
-- Close all buffers except current - use ":BufOnly"
vim.api.nvim_create_user_command("BufOnly", function()
  vim.cmd([[
    %bdelete
    edit #
    bdelete #
  ]])
end, {})

-- ===============================
-- Auto commands
-- ===============================
-- Open NERDTree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("NERDTree | wincmd p")
    end
  end,
})

-- Enable folds when parser is ready
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    local ts_parsers = require("nvim-treesitter.parsers")
    local lang = vim.bo[args.buf].filetype

    -- Confirm Tree-sitter supports this filetype
    if ts_parsers.has_parser(lang) then
      local parser = ts_parsers.get_parser(args.buf, lang)
      if parser then
        vim.schedule(function()
          vim.api.nvim_buf_set_option(args.buf, "foldmethod", "expr")
          vim.api.nvim_buf_set_option(args.buf, "foldexpr", "nvim_treesitter#foldexpr()")
          vim.api.nvim_buf_set_option(args.buf, "foldenable", true)
          vim.api.nvim_buf_set_option(args.buf, "foldlevel", 99)
          vim.cmd("normal! zx")
        end)
      end
    end
  end,
})

-- Strip trimming whitespace and ensure newline at end of file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)

    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])

    -- Ensure file ends with a newline (if not already)
    local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1] or ""
    if last_line ~= "" then
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
    end

    vim.api.nvim_win_set_cursor(0, curpos)
  end,
})

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

