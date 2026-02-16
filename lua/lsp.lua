-- =========================
-- Completion (nvim-cmp)
-- =========================
do
  local ok_cmp, cmp = pcall(require, "cmp")
  local ok_snip, luasnip = pcall(require, "luasnip")
  if ok_cmp and ok_snip then
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Esc>"] = cmp.mapping.abort(),
      }),
      sources = {
        { name = "nvim_lsp" },
      },
    })
  end
end

-- =========================
-- Initialize completion
-- =========================
local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  pcall(function()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  end)
  return capabilities
end

-- =========================
-- Python
-- =========================
local function setup_pyright()
  local pyright = vim.fn.exepath("pyright-langserver")
  if pyright == "" then
    vim.notify(
      "Pyright: pyright-langserver not in PATH",
      vim.log.levels.WARN
    )
    return
  end

  vim.lsp.config("pyright", {
    cmd = { pyright, "--stdio" },
    filetypes = { "python" },
    capabilities = lsp_capabilities(),
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.enable("pyright")
end

-- =========================
-- C/C++
-- =========================
local function setup_clangd()
  local clangd = vim.fn.exepath("clangd")
  if clangd == "" then
    vim.notify("clangd: not in PATH", vim.log.levels.ERROR)
    return
  end

  vim.lsp.config("clangd", {
    cmd = {
      clangd,
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
      "--pch-storage=memory",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    capabilities = lsp_capabilities(),
  })

  vim.lsp.enable("clangd")
end

-- =========================
-- JavaScipt/TypeScript
-- =========================
local function setup_ts()
  local ts = vim.fn.getcwd() .. "/node_modules/.bin/typescript-language-server"

  if vim.fn.executable(ts) == 0 then
    vim.notify(
      "TypeScript LSP: install typescript-language-server locally",
      vim.log.levels.WARN
    )
    return
  end

  vim.lsp.config("ts_ls", {
    cmd = { ts, "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    root_markers = {
      "tsconfig.json",
      "package.json",
      ".git",
    },
    capabilities = lsp_capabilities(),
  })

  vim.lsp.enable("ts_ls")
end

-- =========================
-- Initialize LSP for current buffer
-- =========================
local aug = vim.api.nvim_create_augroup("UserLspSetup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "python",
  callback = setup_pyright,
})

vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = setup_clangd,
})

vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  callback = setup_ts,
})

-- =========================
-- Enable diagnostics
-- =========================
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  float = {
    border = "rounded",
  },
  severity_sort = true,
  update_in_insert = false,
})

vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})
