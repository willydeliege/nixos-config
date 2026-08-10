-- =============================================================================
-- plugins/extras.lua — Small utility plugins
-- =============================================================================
return {
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "kylechui/nvim-surround",
    version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    -- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
    -- config = function()
    --     require("nvim-surround").setup({
    --         -- Put your configuration here
    --     })
    -- end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      highlight = {
        backdrop = true,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          label = "FlashLabel",
        },
      },
    },
    config = function(_, opts)
      -- Apply custom colors using Neovim's highlight API
      vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#4A47A3", fg = "#B8B5FF" })
      vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#456268", fg = "#D0E8F2" })
      vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#A25772", fg = "#EEF5FF", bold = true })
      local flash = require("flash")
      flash.setup(opts)
    end,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },
  -- Improves comment syntax, lets Neovim handle multiple
  -- types of comments for a single language, and relaxes rules
  -- for uncommenting.
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "lambdalisue/vim-suda",
    -- Charge le plugin immédiatement ou à l'appel d'une commande
    cmd = { "SudaRead", "SudaWrite" },
    keys = {
      { "<leader>fSr", "<cmd>SudaRead<CR>", desc = "Suda Read (sudo)" },
      { "<leader>fSw", "<cmd>SudaWrite<CR>", desc = "Suda Write (sudo)" },
    },
    init = function()
      -- Gère de manière transparente les fichiers sans droits en lecture/écriture
      vim.g.suda_smart_edit = 1
    end,
  },

  -- ── Built-in undotree  ──────────────────────────────────────────────────────────────
  {
    -- We provide a placeholder name since it doesn't pull from GitHub
    "nvim.undotree",
    virtual = true, -- Tells lazy.nvim this is a system/built-in package
    keys = {
      {
        "<leader>U",
        function()
          -- Load the built-in module safely if it hasn't been loaded yet
          if not pcall(require, "undotree") then
            vim.cmd("packadd nvim.undotree")
          end
          -- Open the undotree window split
          require("undotree").open()
        end,
        desc = "Toggle Built-in UndoTree",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
}
