-- =============================================================================
-- config/keymaps.lua — Plugin-independent key mappings
-- =============================================================================
-- Conventions:
--   <leader>  = Space (set below)
--   Mappings that require a plugin live in their respective plugin spec file.
-- =============================================================================

vim.g.mapleader = " " -- Space as the leader key
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── General ───────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader><CR>", "<cmd>source %<CR>", { desc = "Source current file" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file exécutable" })

local file_commands = {
  sh = "bash",
  bash = "bash",
  python = "python3",
  javascript = "node",
  typescript = "ts-node",
  lua = "lua",
  perl = "perl",
  ruby = "ruby",
}

local function execute_current_file()
  -- Sauvegarde automatique avant l'exécution
  vim.cmd("silent! write")

  local ft = vim.bo.filetype
  local cmd = file_commands[ft]

  if cmd then
    vim.cmd(string.format("!%s %%", cmd))
  else
    -- Si non listé, tente l'exécution directe si le fichier est exécutable
    vim.cmd("!./%")
  end
end

vim.keymap.set("n", "<leader>fX", execute_current_file, { desc = "Execute script" })
-- ── Better movement ───────────────────────────────────────────────────────────
-- Center screen after jumps
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- ── Window resizing ───────────────────────────────────────────────────────────
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch other buffe" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close other buffers" })

-- ── Line moving in visual mode ────────────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Keep cursor in place when joining lines ───────────────────────────────────
map("n", "J", "mzJ`z", opts)

-- ── Paste without overwriting register ───────────────────────────────────────
map("v", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- ── Diagnostics navigation ───────────────────────────────────────────────────
-- Jump to next/previous diagnostic
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

-- Sauter uniquement aux ERREURS (filtre par sévérité)
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })

-- ── Quickfix list ─────────────────────────────────────────────────────────────
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })

-- ── Indenting in visual mode keeps selection ─────────────────────────────────
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- ── Windows ──────────────────────────────────────────────────────────────────
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- ──  Toggle autoformat for the current buffer only
vim.keymap.set("n", "<leader>bf", function()
  if vim.b.disable_autoformat then
    vim.b.disable_autoformat = false
    print("Autoformat ENABLED for this buffer")
  else
    vim.b.disable_autoformat = true
    print("Autoformat DISABLED for this buffer")
  end
end, { desc = "Toggle autoformat for buffer" })
-- Toggle autoformat globally
vim.keymap.set("n", "<leader>tf", function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    print("Autoformat ENABLED")
  else
    vim.g.disable_autoformat = true
    print("Autoformat DISABLED")
  end
end, { desc = "Toggle autoformat" })

local function copy_markdown_code_block()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- Ligne actuelle (index 0 pour tree-sitter)
  local row = cursor[1] - 1

  -- Recherche du nœud Tree-sitter sous le curseur
  local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, cursor[2] } })

  while node do
    if node:type() == "fenced_code_block" then
      -- Récupère le texte complet du bloc de code
      local text = vim.treesitter.get_node_text(node, bufnr)

      -- Enlève les lignes de backticks au début et à la fin pour garder uniquement le code
      local lines = vim.split(text, "\n")
      if #lines > 2 then
        table.remove(lines, 1) -- Enlève le ```langage
        table.remove(lines, #lines) -- Enlève le dernier ```
        text = table.concat(lines, "\n")
      end

      -- Copie dans le presse-papiers système
      vim.fn.setreg("+", text)
      vim.notify("Bloc de code copié dans le presse-papiers !", vim.log.levels.INFO)
      return
    end
    node = node:parent()
  end
  vim.notify("Aucun bloc de code trouvé sous le curseur.", vim.log.levels.WARN)
end

-- Création d'un raccourci clavier en mode Normal (ex: <leader>yc pour "Yank Code")
vim.keymap.set("n", "<leader>yc", copy_markdown_code_block, { desc = "Copier le bloc de code Markdown" })
local function delete_file_and_buffer()
  -- Prompt for confirmation
  local confirm = vim.fn.confirm("Delete file and close buffer?", "&Yes\n&No", 2)
  if confirm == 1 then
    -- Delete the file from the filesystem
    vim.fn.delete(vim.fn.expand("%"))
    -- Close the buffer
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

-- Map to a key combination, e.g., <leader>df
vim.keymap.set("n", "<leader>fD", delete_file_and_buffer, { desc = "Delete file and buffer" })
