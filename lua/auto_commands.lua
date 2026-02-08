-- ===============================
-- Auto commands
-- ===============================

-- Open NERDTree
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argc() == 0 then
--       vim.cmd("NERDTree | wincmd p")
--     end
--   end,
-- })

-- Remove trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
})

-- Auto-load Session.vim only when starting with NO files/args
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    if vim.fn.argc() ~= 0 then return end
    if vim.fn.filereadable('Session.vim') == 1 then
      -- Defer to end of startup so plugins/colorschemes are ready
      vim.schedule(function()
        -- Source the session
        vim.cmd('silent! source Session.vim')

        -- Re-assert sane color settings in case Session.vim toggled them
        vim.opt.termguicolors = true
        vim.cmd('syntax enable')
        vim.cmd('filetype plugin indent on')

        -- Optional: close initial [No Name] if it’s still around
        pcall(vim.api.nvim_buf_delete, 1, { force = true })
      end)
    end
  end
})
