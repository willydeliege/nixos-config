-- =============================================================================
-- plugins/lsp.lua — Native LSP setup (Lua, Markdown, Bash)
-- =============================================================================
-- Uses:
--   • mason.nvim          — install/manage LSP servers
--   • lazydev.nvim        — Lua LSP enhancements for Neovim plugin development
--   • mason-lspconfig     — bridge between mason and lspconfig
--   • nvim-lspconfig      — configure each server
-- =============================================================================

return {
  -- ── Mason: LSP server installer ─────────────────────────────────────────────
  {
    "williamboman/mason.nvim",
    enabled=false,
    cmd = "Mason",
    keys = { { "<leader>M", "<cmd>Mason<CR>", desc = "Open Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ── lazydev: Neovim Lua API completions ─────────────────────────────────────
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
  },
  -- ── Mason <-> lspconfig bridge ───────────────────────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    -- enabled=false,
    -- dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- Servers that Mason will install automatically
      ensure_installed = {
        "lua_ls", -- Lua
        "bashls", -- Bash / Shell
      },
      automatic_enable = true,
    },
  },

  -- ── Core LSP configuration ───────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
}
