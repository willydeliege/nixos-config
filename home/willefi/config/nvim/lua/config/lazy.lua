-- =============================================================================
-- config/lazy.lua — Bootstrap and configure lazy.nvim
-- =============================================================================
-- lazy.nvim is installed to stdpath("data") .. "/lazy/lazy.nvim".
-- All plugin specs live under lua/plugins/*.lua and are auto-discovered.
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if it is not already present
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- ── Plugin discovery ────────────────────────────────────────────────────────
  spec = {
    { import = "plugins" }, -- loads every lua/plugins/*.lua file
  },

  -- ── Lazy.nvim behaviour ──────────────────────────────────────────────────────
  defaults = {
    lazy = true, -- Load plugins lazily by default
  },

  install = {
    colorscheme = { "habamax" }, -- Fallback colorscheme used during install
  },

  checker = {
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Don't show a notification on startup
  },

  performance = {
    rtp = {
      -- Disable built-in plugins we don't use (speeds up startup)
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
