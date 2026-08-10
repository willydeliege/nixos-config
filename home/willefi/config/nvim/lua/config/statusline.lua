-- ==========================================================================
-- 1. GROUPES DE COULEURS : GITHUB DARK HIGH CONTRAST
-- ==========================================================================
local function set_statusline_hl()
  local colors = {
    -- Arrière-plans & Textes principaux
    mode_bg = "#F0F6FC", -- Blanc pur (Texte du mode pour un contraste maximal)
    mode_fg = "#0A0C10", -- Noir profond GitHub (fond de l'éditeur)
    git_bg = "#161B22", -- Gris foncé GitHub (Canvas Overlay)
    git_fg = "#C9D1D9", -- Texte secondaire
    file_bg = "#0A0C10", -- Noir profond
    file_fg = "#F0F6FC", -- Blanc/Bleu très clair pour le fichier actif
    rest_bg = "#161B22",
    rest_fg = "#8B949E", -- Gris atténué pour les compteurs de lignes

    -- Diagnostics LSP (Couleurs High Contrast)
    err = "#FF908D", -- Rouge clair / Corail
    warn = "#F2CC60", -- Jaune vif
    info = "#71B7FF", -- Bleu clair GitHub
    hint = "#56D4DD", -- Cyan

    -- Git Diff
    git_add = "#44A54E", -- Vert GitHub
    git_chg = "#D29922", -- Orange/Jaune GitHub
    git_del = "#FF7B72", -- Rouge GitHub
  }

  vim.api.nvim_set_hl(0, "StatusMode", { fg = colors.mode_fg, bg = colors.mode_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusGit", { fg = colors.git_fg, bg = colors.git_bg })
  vim.api.nvim_set_hl(0, "StatusFile", { fg = colors.file_fg, bg = colors.file_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusRest", { fg = colors.rest_fg, bg = colors.rest_bg })

  -- Injection des couleurs Git et LSP
  vim.api.nvim_set_hl(0, "StatusGitAdd", { fg = colors.git_add, bg = colors.git_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusGitChg", { fg = colors.git_chg, bg = colors.git_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusGitDel", { fg = colors.git_del, bg = colors.git_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusDiagErr", { fg = colors.err, bg = colors.rest_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusDiagWarn", { fg = colors.warn, bg = colors.rest_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusDiagInfo", { fg = colors.info, bg = colors.rest_bg })
  vim.api.nvim_set_hl(0, "StatusDiagHint", { fg = colors.hint, bg = colors.rest_bg })
end
set_statusline_hl()

vim.api.nvim_create_autocmd("ColorScheme", { callback = set_statusline_hl })

-- ==========================================================================
-- 2. COMPOSANTS DE LA STATUSLINE
-- ==========================================================================

-- A. Mode actuel
local function get_mode()
  local modes = {
    ["n"] = "  NORMAL ",
    ["v"] = "  VISUAL ",
    ["V"] = "  V-LINE ",
    ["\22"] = "  V-BLOCK ",
    ["i"] = "  INSERT ",
    ["R"] = "  REPLACE ",
    ["c"] = "  COMMAND ",
    ["t"] = "  TERMINAL ",
  }
  return modes[vim.api.nvim_get_mode().mode] or " UNKNOWN "
end

-- B. Statut Git complet (via gitsigns)
local function get_git_status()
  local gitsigns = vim.b.gitsigns_status_dict
  if not gitsigns or gitsigns.head == "" then
    return ""
  end

  local status = string.format("  %s", gitsigns.head)

  -- Ajout des compteurs de diff (si existants)
  local added = gitsigns.added and gitsigns.added > 0 and string.format("%%#StatusGitAdd# +%d", gitsigns.added) or ""
  local changed = gitsigns.changed and gitsigns.changed > 0 and string.format("%%#StatusGitChg# ~%d", gitsigns.changed)
    or ""
  local removed = gitsigns.removed and gitsigns.removed > 0 and string.format("%%#StatusGitDel# -%d", gitsigns.removed)
    or ""

  return status .. added .. changed .. removed .. " "
end

-- C. Icône et Nom du Fichier (via nvim-web-devicons)
local function get_file_info()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if filename == "" then
    return "    [No Name] "
  end

  -- Appel natif à nvim-web-devicons
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon, icon_hl = devicons.get_icon(filename, extension, { default = true })
    -- On extrait la couleur de l'icône pour l'injecter proprement
    local hl_color = vim.api.nvim_get_hl(0, { name = icon_hl })
    vim.api.nvim_set_hl(0, "StatusFileIcon", { fg = hl_color.fg, bg = "#1F2335" })

    return string.format(" %%#StatusFileIcon#%s %%#StatusFile#%s %%M%%R ", icon, vim.fn.expand("%:f"))
  end

  return "    %f %M %R "
end

-- D. Diagnostics LSP
local function get_lsp_diagnostics()
  if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
    return ""
  end

  local err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  local status = ""
  if err > 0 then
    status = status .. "%#StatusDiagErr#  " .. err
  end
  if warn > 0 then
    status = status .. "%#StatusDiagWarn#  " .. warn
  end
  if info > 0 then
    status = status .. "%#StatusDiagInfo#  " .. info
  end
  if hint > 0 then
    status = status .. "%#StatusDiagHint#    " .. hint
  end

  return status ~= "" and status .. " " or ""
end

-- ==========================================================================
-- 3. ASSEMBLAGE ET REFRESH
-- ==========================================================================
function _G.custom_statusline()
  return table.concat({
    "%#StatusMode#",
    get_mode(),
    "%#StatusGit#",
    get_git_status(),
    get_file_info(),
    "%=", -- Séparateur Gauche / Droite
    get_lsp_diagnostics(),
    "%#StatusRest#",
    " %y │  %l:%c │ %p%% ",
  })
end

vim.opt.statusline = "%{%v:lua.custom_statusline()%}"
