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
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Esc>"] = cmp.mapping.abort(),
      }),
      sources = {
        { name = "nvim_lsp" },
      },
    })
  end
end

-- =========================
-- LSP (builtin): pyright
-- =========================
do
  local pyright = vim.fn.exepath("pyright-langserver")
  if pyright == "" then
    vim.notify(
      "Pyright: pyright-langserver not in PATH (is venv active?)",
      vim.log.levels.WARN
    )
    return
  end

  -- Capabilities: LSP -> nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  pcall(function()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  end)

  vim.lsp.config("pyright", {
    cmd = { pyright, "--stdio" },
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic", -- or "strict"
          diagnosticMode = "workspace",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  })

  vim.lsp.enable("pyright")
end
