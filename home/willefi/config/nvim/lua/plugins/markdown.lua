return {
  {
    "obsidian-nvim/obsidian.nvim",
    cmd = { "Obsidian", "ObsidianCapture" },
    keys = {
      { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian find files" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Obsidian links" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian new note" },
      { "<leader>oT", "<cmd>Obsidian tags<cr>", desc = "Obsidian tags" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian today" },
      { "<leader>ox", "<cmd>ObsidianCapture<cr>", desc = "Obsidian capture" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in 4.0.0
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/MyPkm/",
        },
      },
      ui = { enable = false },
      picker = {
        name = "snacks.picker",
      },
      checkbox = {
        create_new = true,
        order = { " ", "x" },
      },
      daily_notes = {
        folder = "Daily",
        template = "daily_note.md",
      },
      ---@diagnostic disable-next-line: missing-fields
      templates = {
        folder = "Templates/",
      },
      cache = { enabled = true },
    },
    config = function(_, opts)
      local note_name = { note_id_func = require("obsidian.builtin").title_id }
      local new_opts = vim.tbl_extend("force", opts, note_name)
      require("obsidian").setup(new_opts)

      vim.api.nvim_create_user_command("ObsidianCapture", function()
        local today_note = require("obsidian.daily").today()

        -- Utilisation de vim.fn.input (synchrone, insensible aux conflits d'UI)
        local status, input_text = pcall(vim.fn.input, "Capture : ")

        if status and input_text and input_text ~= "" then
          today_note:insert_text(
            "- " .. input_text .. " #inbox",
            { placement = "bot", on_section_missing = "create", section = { level = 2, header = "Inbox" } }
          )
          vim.notify("Added to today's note")
        else
          vim.notify("Capture canceled or empty")
        end
      end, {})
    end,
  },
  -- For `plugins/markview.lua` users.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        position = "overlay",
        border = true,
      },
    },
  },
}
