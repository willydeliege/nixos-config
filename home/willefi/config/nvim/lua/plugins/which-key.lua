---@diagnostic disable: undefined-field
-- =============================================================================
-- plugins/which-key.lua — Key binding popup and group labels
-- =============================================================================
-- which-key shows a popup with available key bindings when you pause mid-chord.
-- Groups organise mappings into labelled sections visible in the popup.
--
-- Section layout:
--   <leader>f  → Find / Files
--   <leader>s  → Search
--   <leader>t  → Toggle
--   <leader>q  → Quit
-- =============================================================================

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- Load after startup so it doesn't slow down init
    version = "*",
    debug = true,
    opts = {
      -- ── Popup appearance ──────────────────────────────────────────────────────
      preset = "helix", -- "classic" | "modern" | "helix"
      delay = 300, -- Milliseconds before the popup appears (matches timeoutlen)

      -- ── Layout ───────────────────────────────────────────────────────────────
      layout = {
        width = { min = 20 },
        spacing = 3,
      },

      plugins = {
        spelling = {
          enabled = true, -- Enable spelling suggestions in which-key
        },
      },
      -- ── Filters: hide mappings that clutter the popup ─────────────────────────
      filter = function(mapping)
        -- Show only mappings that have a description
        return mapping.desc and mapping.desc ~= ""
      end,

      -- ── Plugin-specific display ───────────────────────────────────────────────
      show_help = true,
      show_keys = true,
      disable = {
        -- Disable which-key inside these filetypes
      },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- ── Group labels ───────────────────────────────────────────────────────────
      -- These labels appear as section headers in the which-key popup.
      wk.add({
        -- ── Windows ────────────────────────────────────────────────────────────
        -- ── Find / Files ───────────────────────────────────────────────────────
        { "<leader>b", group = "Buffers" },
        { "<leader>f", group = "Find / Files" },
        { "<leader>fS", group = "Suda" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>gt", group = "Git toggle" },
        { "<leader>h", group = "Help" },
        { "<leader>o", group = "Obsidian" },
        { "<leader>y", group = "Yank" },

        -- ── Search ─────────────────────────────────────────────────────────────
        { "<leader>s", group = "Search" },
        -- ── Windows ────────────────────────────────────────────────────────────
        { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings

        -- ── Toggle ─────────────────────────────────────────────────────────────
        { "<leader>t", group = "Toggle", icon = { icon = "󰔡 ", color = "green" } },
        {
          "<leader>tC",
          function()
            local enabled = vim.opt.colorcolumn:get()[1] ~= ""
            vim.opt.colorcolumn = enabled and "" or "80"
            vim.notify("Colorcolumn: " .. (enabled and "OFF" or "ON"))
          end,
          desc = "Colorcolumn",
        },

        -- ── Quit ───────────────────────────────────────────────────────────────
        { "<leader>q", group = "Quit", icon = { icon = "󰩈 ", color = "red" } },
        { "<leader>qr", "<cmd>restart<CR>", desc = "Resart" },
        { "<leader>qq", "<cmd>qall<CR>", desc = "Quit all" },
        { "<leader>qc", "<cmd>close<CR>", desc = "Close window" },
        { "<leader>qQ", "<cmd>qall!<CR>", desc = "Quit all (force)" },
        { "<leader>qs", "<cmd>wqall<CR>", desc = "Save all and quit" },
        { "<leader>qb", "<cmd>bdelete<CR>", desc = "Close buffer" },
        { "<leader>qB", "<cmd>bdelete!<CR>", desc = "Close buffer (force)" },

        -- ── Code (LSP) ─────────────────────────────────────────────────
        { "<leader>c", group = "Code" },
        { "<leader>cc", group = "Code lens" },

        -- ── Trouble  ─────────────────────────────────────────────────
        { "<leader>x", group = "Trouble" },
      })
    end,
  },
}
