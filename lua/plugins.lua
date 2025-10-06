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
  -- Misc
  { "nvim-tree/nvim-web-devicons" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Theme: Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 1
      vim.cmd("colorscheme gruvbox-material")
    end,
    priority = 1000,
  },

  -- UI & Navigation
  {
    "preservim/nerdtree",
    config = function()
      vim.g.NERDTreeShowHidden = 1
    end,
  },
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
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      })
    end
  },

  -- GIT integration
  { "lewis6991/gitsigns.nvim" },

  -- LSP & Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "onsails/lspkind-nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "html",
          "css",
          "rust",
          "json",
          "c",
          "cpp",
        },
        highlight = { enable = true },
        indent = { enable = true },
        folds = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["af"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  -- Telescope + extras
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",  -- stay pinned; upgrade intentionally later
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzy-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope: Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep()  end, desc = "Telescope: Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers()    end, desc = "Telescope: Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags()  end, desc = "Telescope: Help tags" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles()   end, desc = "Telescope: Recent files" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Telescope: Doc symbols" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 10,
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        pickers = {
          find_files = { hidden = true, follow = true },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      })
      -- Load extensions
      pcall(telescope.load_extension, "fzy_native")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
})

require("nvim-treesitter.install").prefer_git = true
require("nvim-treesitter.configs")
