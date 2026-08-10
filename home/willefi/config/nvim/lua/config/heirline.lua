local conditions = require("heirline.conditions")

--------------------------------------------------
-- Colors
--------------------------------------------------

local colors = {
  bg = "#2b2b2b", -- dark grey
  fg = "#d4d4d4",

  blue = "#569cd6",
  green = "#6a9955",
  red = "#f44747",
  yellow = "#dcdcaa",
  orange = "#ce9178",
  purple = "#c586c0",
  cyan = "#4ec9b0",

  diag_error = "#f44747",
  diag_warn = "#ffcc66",
  diag_info = "#4fc1ff",
  diag_hint = "#10b981",

  git_add = "#6a9955",
  git_change = "#d7ba7d",
  git_del = "#f44747",
}

--------------------------------------------------
-- Vi Mode
--------------------------------------------------

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "NORMAL",
      no = "N-PENDING",
      i = "INSERT",
      ic = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      ["\22"] = "V-BLOCK",
      c = "COMMAND",
      s = "SELECT",
      S = "S-LINE",
      R = "REPLACE",
      t = "TERMINAL",
    },
  },
  provider = function(self)
    return "  " .. (self.mode_names[self.mode] or self.mode)
  end,
  hl = function(self)
    local mode = self.mode

    if mode:match("^n") then
      return { fg = colors.green, bold = true }
    elseif mode:match("^i") then
      return { fg = colors.blue, bold = true }
    elseif mode:match("^v") then
      return { fg = colors.purple, bold = true }
    elseif mode:match("^R") then
      return { fg = colors.red, bold = true }
    else
      return { fg = colors.yellow, bold = true }
    end
  end,
}

--------------------------------------------------
-- File Name
--------------------------------------------------

local FileName = {
  provider = function()
    local name = vim.fn.expand("%:~:.")
    if name == "" then
      return "[No Name]"
    end
    return " " .. name
  end,
  hl = { bold = true },
}
local FileModified = {
  provider = function()
    -- Check if the current buffer has unsaved changes
    if vim.bo.modified then
      return " [●]" -- You can replace this with any icon, e.g., "●"
    end
  end,
  hl = { fg = "orange" }, -- Customize the highlight color here
}

--------------------------------------------------
-- Git Branch
--------------------------------------------------

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status = vim.b.gitsigns_status_dict
  end,
  {
    provider = function(self)
      if self.status.head and self.status.head ~= "" then
        return "  " .. self.status.head .. " "
      end
    end,
    hl = { fg = colors.orange },
  },

  {
    provider = function(self)
      local added = self.status.added or 0
      return added > 0 and ("+ " .. added .. " ")
    end,
    hl = { fg = colors.git_add },
  },

  {
    provider = function(self)
      local changed = self.status.changed or 0
      return changed > 0 and ("~ " .. changed .. " ")
    end,
    hl = { fg = colors.git_change },
  },

  {
    provider = function(self)
      local removed = self.status.removed or 0
      return removed > 0 and ("- " .. removed .. " ")
    end,
    hl = { fg = colors.git_del },
  },
}

--------------------------------------------------
-- Diagnostics
--------------------------------------------------

local Diagnostics = {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = " ",
    warn_icon = " ",
    info_icon = " ",
    hint_icon = "󰌵 ",
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })

    self.warnings = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })

    self.info = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.INFO,
    })

    self.hints = #vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    })
  end,

  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = colors.red },
  },

  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = colors.yellow },
  },

  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = colors.blue },
  },

  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
    end,
    hl = { fg = colors.cyan },
  },
}

--------------------------------------------------
-- LSP
--------------------------------------------------

local LSPActive = {
  condition = conditions.lsp_attached,

  provider = function()
    local names = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      table.insert(names, client.name)
    end

    return "  " .. table.concat(names, ", ")
  end,

  hl = { fg = colors.green },
}

--------------------------------------------------
-- Encoding
--------------------------------------------------

local FileEncoding = {
  provider = function()
    return string.upper(vim.bo.fileencoding)
  end,
  hl = { fg = colors.gray },
}

--------------------------------------------------
-- Filetype
--------------------------------------------------

local FileType = {
  provider = function()
    return " " .. vim.bo.filetype
  end,
  hl = { fg = colors.cyan },
}

--------------------------------------------------
-- Position
--------------------------------------------------

local Ruler = {
  provider = " %l:%c %P ",
  hl = { fg = colors.fg, bold = true },
}

--------------------------------------------------
-- Align
--------------------------------------------------

local Align = {
  provider = "%=",
}

--------------------------------------------------
-- Statusline
--------------------------------------------------

local StatusLine = {
  hl = {
    fg = colors.fg,
    bg = colors.bg,
  },

  ViMode,
  { provider = " │ " },

  Git,
  { provider = " │ " },

  FileName,

  FileModified,

  Align,

  Diagnostics,
  { provider = "  " },

  LSPActive,
  { provider = " │ " },

  FileEncoding,
  { provider = " │ " },

  FileType,
  { provider = " │ " },

  Ruler,
}

require("heirline").setup({
  statusline = StatusLine,
})
