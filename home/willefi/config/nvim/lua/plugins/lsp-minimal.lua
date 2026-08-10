-- ~/.config/nvim/lua/plugins/lsp.lua
--
-- Config minimale : lua_ls + markdown_oxide
-- Portable NixOS <-> Arch : le cmd des serveurs (ex: "markdown-oxide")
-- est juste cherché sur le $PATH, peu importe qui l'y a mis.
--
--   - Sur Arch : Mason installe les binaires normalement (aucun souci FHS).
--   - Sur NixOS : n'installe PAS ces serveurs via Mason (binaires précompilés
--     = problèmes de dynamic linker hors FHS). Utilise plutôt nixpkgs :
--       home.packages = with pkgs; [ lua-language-server markdown-oxide ];
--     Ils seront sur le PATH, et cette même config les trouvera sans
--     rien changer. (Alternative si tu veux vraiment garder Mason sur
--     NixOS : https://github.com/nix-community/nix-ld)

return {
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

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- blink.cmp fournit ses propres capabilities étendues
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("bashls", {
        cmd = { "bash-language-server", "start" },
        ---@type lspconfig.settings.bashls
        settings = {
          bashIde = {
            -- Glob pattern for finding and parsing shell script files in the workspace.
            -- Used by the background analysis features across files.

            -- Prevent recursive scanning which will cause issues when opening a file
            -- directly in the home directory (e.g. ~/foo.sh).
            --
            -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
            globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
          },
        },
        filetypes = { "bash", "sh" },
        root_markers = { ".git" },
      })
      vim.lsp.enable("bashls")
      vim.lsp.config("lua_ls", { settings = {} })
      vim.lsp.enable("lua_ls")

      vim.lsp.config("nil_ls", { settings = {} })
      vim.lsp.enable("nil_ls")
      -- markdown-oxide : fusionne (ne remplace pas) la config par défaut
      -- fournie par nvim-lspconfig (cmd, filetypes, root_markers).
      vim.lsp.config("markdown_oxide", {
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangeWatchedFiles = { dynamicRegistration = true },
          },
        }),
      })
      vim.lsp.enable("markdown_oxide")

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },
  { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
}
