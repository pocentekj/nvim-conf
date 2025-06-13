-- ===============================
-- LSP Setup
-- ===============================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python
lspconfig.pyright.setup({
  before_init = function(_, config)
    local function get_python_path(workspace)
      local paths = {
        workspace .. "/.venv/bin/python",
        workspace .. "/venv/bin/python",
      }
      for _, path in ipairs(paths) do
        if vim.fn.executable(path) == 1 then return path end
      end
      local fallback = os.getenv("HOME") .. "/.local/share/lsp-python-tools/bin/python"
      if vim.fn.executable(fallback) == 1 then return fallback end
      return "python3"
    end

    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = get_python_path(config.root_dir)
  end,
  capabilities = capabilities,
})

-- JS/TS

local function get_node_bin_path(root_dir, bin)
  local local_bin = root_dir .. "/node_modules/.bin/" .. bin
  if vim.fn.executable(local_bin) == 1 then
    return local_bin
  end
  return os.getenv("HOME") .. "/.local/share/lsp-node-tools/node_modules/.bin/" .. bin
end

lspconfig.ts_ls.setup({
  on_new_config = function(new_config, root_dir)
    new_config.cmd = {
      get_node_bin_path(root_dir, "typescript-language-server"),
      "--stdio",
    }
    new_config.init_options = {
      hostInfo = "neovim",
      preferences = {
        disableSuggestions = false
      }
    }
  end,
  capabilities = capabilities,
})

lspconfig.html.setup({
  on_new_config = function(new_config, root_dir)
    new_config.cmd = {
      get_node_bin_path(root_dir, "vscode-html-language-server"),
      "--stdio",
    }
  end,
  capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
    },
  },
})

-- C/C++
lspconfig.clangd.setup({ capabilities = capabilities })

-- ===============================
-- Completion
-- ===============================
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = { { name = "nvim_lsp" } },
})
