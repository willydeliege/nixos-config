-- =============================================================================
-- init.lua — Neovim 0.12 entry point
-- =============================================================================
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = "msg", -- Default target for messages
  },
})
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("config.statusline")
