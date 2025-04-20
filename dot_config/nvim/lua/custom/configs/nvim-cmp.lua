local M = {}

function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")
  
  -- Load friendly-snippets if installed
  local status, vscode_loader = pcall(require, "luasnip.loaders.from_vscode")
  if status then
    vscode_loader.lazy_load()
  end
  
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "path" },
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
        menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        },
      }),
    },
  })
  
  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

-- Setup LSP capabilities for C++ development
function M.setup_lsp_capabilities()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  return capabilities
end

-- LSP configuration for C++
function M.setup_cpp_lsp()
  local capabilities = M.setup_lsp_capabilities()
  
  require("lspconfig").clangd.setup {
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  }
end

-- Setup C++ custom highlights
function M.setup_cpp_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      -- C++ specific highlight groups
      vim.api.nvim_set_hl(0, "CppType", { fg = "#5fd7ff" })
      vim.api.nvim_set_hl(0, "CppFunction", { fg = "#87ff00" })
      vim.api.nvim_set_hl(0, "CppNamespace", { fg = "#af87ff" })
      vim.api.nvim_set_hl(0, "CppMacro", { fg = "#ff8700" })
      vim.api.nvim_set_hl(0, "CppConstant", { fg = "#ffff00" })
      vim.api.nvim_set_hl(0, "CppString", { fg = "#d7af87" })
      vim.api.nvim_set_hl(0, "CppComment", { fg = "#8a8a8a" })
    end,
  })
end

-- Setup LSP keybindings
function M.setup_lsp_keymaps()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })
end

-- Setup Treesitter for better syntax highlighting
function M.setup_treesitter()
  require("nvim-treesitter.configs").setup({
    ensure_installed = { 
      "c", "cpp", "lua", "vim", "vimdoc", "query",
      -- Add other languages you commonly use
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  })
end

-- Initialize everything
function M.init()
  M.setup()
  M.setup_cpp_lsp()
  M.setup_cpp_highlights()
  M.setup_lsp_keymaps()
  M.setup_treesitter()
end

return M
