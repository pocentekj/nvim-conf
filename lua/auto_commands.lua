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

