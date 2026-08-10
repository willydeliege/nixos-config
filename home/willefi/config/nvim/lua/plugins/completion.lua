---@diagnostic disable: undefined-field
-- =============================================================================
-- plugins/completion.lua — blink.cmp with snippets
-- =============================================================================
-- blink.cmp is a fast, Rust-powered completion engine for Neovim.
-- Snippets are handled through friendly-snippets (VSCode-style snippet packs)
-- loaded via blink's built-in snippet source.
-- =============================================================================

return {
  -- ── VSCode snippet collection ────────────────────────────────────────────────
  {
    "rafamadriz/friendly-snippets",
    -- Loaded automatically when blink.cmp starts up
  },

  -- ── blink.cmp ────────────────────────────────────────────────────────────────
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.lib",
      -- optional: provides snippets for the snippet source
      "rafamadriz/friendly-snippets",
    },
    -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
    -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    build = function()
      require("blink.cmp").build():pwait()
    end,
    event = "VeryLazy",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- ── Key bindings ──────────────────────────────────────────────────────────
      keymap = {
        preset = "default",
        -- Accept with <CR>
        ["<CR>"] = { "accept", "fallback" },
        -- Navigate the menu with <Tab> / <S-Tab>
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        -- Scroll documentation
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        -- Trigger completion manually
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        -- Close the menu
        ["<C-e>"] = { "hide", "fallback" },
        ["jk"] = { "hide" },
      },

      fuzzy = { implementation = "prefer_rust" },

      -- ── Appearance ────────────────────────────────────────────────────────────
      appearance = {
        -- "mono" aligns icons with Nerd Font Mono; use "normal" for standard fonts
        nerd_font_variant = "mono",
      },

      -- ── Completion sources ────────────────────────────────────────────────────
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          markdown = {
            "lsp",
            inherit_defaults = true,
          },
          lua = {
            inherit_defaults = true,
            "lazydev",
          },
        },
        providers = {
          -- lazydev source for Neovim Lua API completions
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- Higher score = shown before LSP results
            score_offset = 100,
          },
        },
      },
      cmdline = { enabled = false },

      -- ── Signature help ────────────────────────────────────────────────────────
      signature = {
        enabled = true, -- Show function signature when typing arguments
        window = { border = "rounded" },
      },

      -- ── Completion menu ───────────────────────────────────────────────────────
      completion = {
        accept = {
          -- Expand snippets on accept
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true, -- Show docs automatically
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          -- Draw columns: kind icon, label, kind name, source
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
              { "source_name" },
            },
          },
        },
        -- Show ghost text preview for the selected item
        ghost_text = { enabled = false },
      },
    },
  },
}
