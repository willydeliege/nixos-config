-- =============================================================================
-- config/options.lua — Global Neovim options
-- =============================================================================

local opt = vim.opt

-- ── UI ────────────────────────────────────────────────────────────────────────
opt.showtabline = 0
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers (hybrid mode)
opt.signcolumn = "yes" -- Always show the sign column (avoids layout shift)
opt.cursorline = true -- Highlight the current line
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.showmode = false -- Mode is shown by the status line instead
opt.laststatus = 3 -- Single global status line (Neovim 0.7+)
opt.cmdheight = 0 -- Command-line height
opt.pumheight = 10 -- Maximum number of items in the popup menu
opt.pumborder = "rounded" -- mini floats like completions
opt.scrolloff = 8 -- Keep 8 lines visible above/below the cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of the cursor
opt.splitbelow = true -- Horizontal splits open below
opt.splitright = true -- Vertical splits open to the right

-- ── Editing ───────────────────────────────────────────────────────────────────
opt.expandtab = true -- Convert tabs to spaces
opt.tabstop = 2 -- A <Tab> counts for 4 spaces
opt.shiftwidth = 2 -- Indentation width for << / >>
opt.softtabstop = 4 -- <Tab> in insert mode inserts 4 spaces
opt.smartindent = true -- Auto-indent new lines
opt.breakindent = true -- Wrapped lines preserve indentation
opt.virtualedit = "block" -- Allow cursor to move freely in visual-block mode

-- ── Search ────────────────────────────────────────────────────────────────────
opt.ignorecase = true -- Case-insensitive search ...
opt.smartcase = true -- ... unless the pattern contains uppercase
opt.hlsearch = true -- Highlight all search matches
opt.incsearch = true -- Incremental search highlighting

-- ── Files & Encoding ─────────────────────────────────────────────────────────
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.undofile = true -- Persistent undo across sessions
opt.swapfile = false -- No swap files
opt.backup = false -- No backup files
opt.updatetime = 200 -- Faster CursorHold events (used by LSP)
opt.timeoutlen = 300 -- Timeout for which-key to appear (ms)

-- ── Completion ────────────────────────────────────────────────────────────────
vim.opt.completeopt = { "menu", "popup", "noselect", "fuzzy" }
-- ── Clipboard ────────────────────────────────────────────────────────────────
-- Uses the system clipboard. Requires xclip/xsel on Linux or pbcopy on macOS.
opt.clipboard = "unnamedplus"

-- ── Folding (using Treesitter when available) ────────────────────────────────
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- Start with all folds open

-- ── Misc ─────────────────────────────────────────────────────────────────────
opt.mouse = "a" -- Enable mouse in all modes
opt.list = true -- Show invisible characters
opt.listchars = { tab = ">> ", trail = ".", nbsp = "~" }
opt.confirm = true
vim.diagnostic.config({ virtual_text = { current_line = true } })
