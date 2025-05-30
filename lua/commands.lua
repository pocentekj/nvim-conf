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

