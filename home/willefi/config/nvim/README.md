# Neovim 0.12 Configuration

A well-structured Neovim configuration targeting Neovim **0.12+**, organised
around native features (LSP, Treesitter, snippets) with lazy.nvim as the
package manager.

## Directory layout

```
~/.config/nvim/
├── init.lua                  Entry point — loads config/* in order
└── lua/
    ├── config/
    │   ├── options.lua       vim.opt settings
    │   ├── keymaps.lua       Plugin-independent key mappings
    │   └── lazy.lua          lazy.nvim bootstrap & setup
    └── plugins/
        ├── colorscheme.lua   catppuccin theme
        ├── treesitter.lua    Syntax highlighting & text objects
        ├── lsp.lua           Mason + lspconfig (Lua, Markdown, Bash)
        ├── completion.lua    blink.cmp + friendly-snippets
        ├── conform.lua       Code formatting (stylua, shfmt, prettier)
        ├── oil.lua           File explorer
        ├── fzf.lua           Fuzzy finder (fzf-lua)
        ├── which-key.lua     Key binding popup & group labels
        ├── statusline.lua    lualine status line
        └── extras.lua        mini.nvim, gitsigns, todo-comments
```

## Installation

```bash
# Back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone / copy this config
cp -r /path/to/this/nvim ~/.config/nvim

# Start Neovim — lazy.nvim auto-installs everything
nvim
```

On first launch lazy.nvim clones itself and installs all plugins.
Run `:Lazy` to view plugin status.

## External dependencies

Install these with your system package manager:

| Tool        | Used by                   | Install (e.g. Ubuntu / macOS)    |
|-------------|---------------------------|----------------------------------|
| `fzf`       | fzf-lua                   | `apt install fzf` / `brew install fzf` |
| `ripgrep`   | fzf-lua live grep         | `apt install ripgrep` / `brew install ripgrep` |
| `fd`        | fzf-lua file find         | `apt install fd-find` / `brew install fd` |
| `node`      | bashls, marksman via Mason| `nvm install --lts` |
| `stylua`    | conform (Lua)             | `cargo install stylua` or Mason |
| `shfmt`     | conform (Shell)           | `go install mvdan.cc/sh/v3/cmd/shfmt@latest` or Mason |
| `prettier`  | conform (Markdown/JSON)   | `npm i -g prettier` or Mason |

LSP servers (lua_ls, marksman, bashls) are installed automatically via Mason
on first launch.

## Key mapping reference

`<leader>` is **Space**.

### Find / Files  `<leader>f`

| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>ff`  | Find files                    |
| `<leader>fr`  | Recent files                  |
| `<leader>fb`  | Find open buffers             |
| `<leader>fB`  | Lines in current buffer       |
| `<leader>fp`  | Git-tracked files             |
| `<leader>fe`  | File explorer (Oil)           |
| `-`           | Open parent dir (Oil)         |
| `<leader>-`   | Open Oil in a float           |

### Search  `<leader>s`

| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>sg`  | Live grep                     |
| `<leader>sw`  | Grep word under cursor        |
| `<leader>sv`  | Grep visual selection         |
| `<leader>sr`  | Resume last search            |
| `<leader>sd`  | Document diagnostics          |
| `<leader>sD`  | Workspace diagnostics         |
| `<leader>ss`  | LSP symbols (document)        |
| `<leader>sS`  | LSP symbols (workspace)       |
| `<leader>sh`  | Help tags                     |
| `<leader>sk`  | Keymaps                       |
| `<leader>sm`  | Marks                         |

### Toggle  `<leader>t`

| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>ts`  | Spell check                   |
| `<leader>tw`  | Word wrap                     |
| `<leader>tn`  | Cycle line numbers            |
| `<leader>th`  | Search highlight              |
| `<leader>tc`  | Colorcolumn (80)              |
| `<leader>ti`  | Inlay hints (LSP)             |

### Quit  `<leader>q`

| Key           | Action                        |
|---------------|-------------------------------|
| `<leader>qq`  | Quit all                      |
| `<leader>qQ`  | Force quit all                |
| `<leader>qs`  | Save all and quit             |
| `<leader>qb`  | Close buffer                  |
| `<leader>qB`  | Force close buffer            |

### LSP (active in LSP buffers)

| Key           | Action                        |
|---------------|-------------------------------|
| `gd`          | Go to definition              |
| `gD`          | Go to declaration             |
| `gr`          | List references               |
| `gi`          | Go to implementation          |
| `K`           | Hover documentation           |
| `gK`          | Signature help                |
| `<leader>ca`  | Code action                   |
| `<leader>cr`  | Rename symbol                 |
| `<leader>cf`  | Format buffer / selection     |

### Git (gitsigns)

| Key             | Action              |
|-----------------|---------------------|
| `]h` / `[h`     | Next / prev hunk    |
| `<leader>ghs`   | Stage hunk          |
| `<leader>ghr`   | Reset hunk          |
| `<leader>ghp`   | Preview hunk        |
| `<leader>ghb`   | Blame line          |

## Customisation tips

- **Colorscheme**: edit `plugins/colorscheme.lua` — swap the plugin and the
  `colorscheme` call.
- **Add a language**: add the parser to `ensure_installed` in
  `treesitter.lua`, the server to `mason-lspconfig` opts in `lsp.lua`,
  and a formatter entry in `conform.lua`.
- **Formatters**: run `:Mason` and install formatters there, or add them to
  `mason-conform` if you add that bridge plugin.
- **Snippets**: drop extra `*.json` snippet files into
  `~/.config/nvim/snippets/` — blink.cmp picks them up automatically.
