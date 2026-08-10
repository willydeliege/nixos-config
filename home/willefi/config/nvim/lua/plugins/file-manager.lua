---@type LazySpec
return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>fe",
        "<cmd>Yazi cwd<cr>",
        desc = "File explorer (cwd)",
      },
      {
        "<leader>ty",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,

      -- the floating window scaling factor. 1 means 100%, 0.9 means 90%, etc.
      floating_window_scaling_factor = 1.0,
      keymaps = {
        show_help = "<C-h>",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sG",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Search and replace (Grug)",
      },
      {
        "<leader>sW",
        function()
          require("grug-far").open({
            prefills = { search = vim.fn.expand("<cword>") },
            transient = true,
          })
        end,
        desc = "Search current word (Grug)",
      },
    },
    opts = {
      -- Options de configuration (laisser vide pour les valeurs par défaut)
      headerMaxWidth = 80,
      -- Vous pouvez forcer l'utilisation de ripgrep si nécessaire
      engines = {
        ripgrep = {
          path = "rg",
        },
      },
    },
  },
}
