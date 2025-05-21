-- ===============================
-- Lazy.nvim Bootstrap
-- ===============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===============================
-- Plugins
-- ===============================
require("lazy").setup({
  -- UI & Navigation
  { 
    "preservim/nerdtree",
    config = function()
      vim.g.NERDTreeShowHidden = 1
    end,
  },
  { "jlanzarotta/bufexplorer" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          always_show_bufferline = true,
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", padding = 1 },
          },
        },
      })
    end,
  },

  -- GIT integration
  { "lewis6991/gitsigns.nvim" },

  -- LSP & Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "onsails/lspkind-nvim" },

  -- Theme
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        }
      })
      vim.cmd("colorscheme terafox")
    end
  },
})
