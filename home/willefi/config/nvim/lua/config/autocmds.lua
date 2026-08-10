-- =============================================================================
-- config/autocmds.lua — Autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ---------------------------------------------------------------------------
-- Highlight on yank
-- ---------------------------------------------------------------------------
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
  desc = "Flash the yanked region",
})

-- ---------------------------------------------------------------------------
-- Restore cursor position when reopening a file
-- ---------------------------------------------------------------------------
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Jump to last known cursor position",
})

-- ---------------------------------------------------------------------------
-- Resize splits when the terminal window is resized
-- ---------------------------------------------------------------------------
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Equalize split sizes on terminal resize",
})

-- ---------------------------------------------------------------------------
-- Close certain windows with just <q>
-- ---------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = { "help", "lspinfo", "man", "notify", "qf", "checkhealth", "oil" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
  desc = "Close auxiliary windows with q",
})

-- -- ---------------------------------------------------------------------------
-- -- Enable spell-checking and text-width for prose files
-- -- ---------------------------------------------------------------------------
-- spell.lua - Spell checking for markdown, gitcommit, and text files

local spell_group = vim.api.nvim_create_augroup("SpellCheck", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "fr" }
    vim.opt_local.spelloptions = "camel" -- handle camelCase words gracefully
  end,
})

-- ---------------------------------------------------------------------------
-- Remove trailing whitespace on save (non-binary files)
-- ---------------------------------------------------------------------------
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    if not vim.bo.binary then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
  desc = "Strip trailing whitespace before writing",
})

-- ---------------------------------------------------------------------------
-- Show man pages and help in a split window to the right
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  callback = function()
    vim.cmd("wincmd L")
  end,
})

-- ---------------------------------------------------------------------------
-- Treesitter
-- ---------------------------------------------------------------------------

-- Define languages you want to target
local ts_languages = { "lua", "markdown", "mardkown_inline", "nix" }

-- Enable native Tree-sitter highlighting when a file loads
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_languages,
  callback = function(args)
    -- Ensure Neovim 0.12 safely verifies a parser exists before starting
    if vim.treesitter.get_parser(args.buf) then
      vim.treesitter.start(args.buf)
    end
  end,
})
