local function sesh_picker()
  local output = vim.fn.systemlist("sesh list --hide-duplicates")

  Snacks.picker({
    title = "Tmux Sessions",
    items = vim.tbl_map(function(session)
      return {
        text = session,
        session = session,
      }
    end, output),

    format = function(item)
      return { { item.text } }
    end,

    confirm = function(picker, item)
      picker:close()

      -- If inside tmux
      vim.fn.jobstart({ "sesh", "connect", item.session }, {
        detach = true,
      })
    end,
  })
end

vim.keymap.set("n", "<leader>fp", sesh_picker, {
  desc = "Tmux Sessions",
})
