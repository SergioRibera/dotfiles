# Nvim Dotfiles
I'll keep adding new features like snippets etc and clean the config , make neovim (cli version) as functional as an IDE . Pull requests are welcome.

## Screenshots
### Gerenal
---
---
---

### Features
- Cycle Theme
- Save and load current theme cycled
- Languajes Support:
    - C# (Need Roselyn bin, for more information see [this]())
    - Lua
    - Lua (Nvim Library)
    - C/C++ (With clang)
    - Python
    - Rust
    - Dart
    - Javascript
    - Typescript
    - React (Jsx or Tsx)
    - Html
    - Css
    - Bash
    - Json
    - Yaml
    - Markdown
- File navigation with Nvimtree
- Mouse works
- Icons on nvimtree, telescope with nvim-web-devicons
- Minimal status line (lualine)
- Gitsigns (colored bars in my config)
- Using nvim-lsp
- Show pictograms on autocompletion items
- Packer.nvim as package manager
- Snip support from VSCode through vsnip supporting custom and predefined snips (friendly-snippets)

### Cycle Theme System
This is a custom system with autoload on open Nvim, this load last theme selected
    - Material
    - One Dark (With Background transparent)
    - Nord
> If you want add other theme, i use [nvim-base16](https://github.com/norcalli/nvim-base16.lua) for themes so you can search some themes for add, the next step is modify the `lua/mappings/lua.lua` file on line `16` adding a theme in the list

### Plugins
- [packer](https://github.com/wbthomason/packer.nvim) - `Not have configuration File` but a list of plugins stay on `lua/pluginList/lua.lua`
    - To install plugins natively
    - a
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - `init.lua`
    - To amazing ident Lines
    - a 
- [nvim-base16](https://github.com/norcalli/nvim-base16.lua) - `lua/mappings/lua.lua` to edit themes list
    - Programmatic lua library for setting [base16](https://github.com/chriskempson/base16) themes in Neovim
    - a
- [colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - `Not have configuration File`
    - A high-performance color highlighter for Neovim
    - a
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - `lua/treesitter/lua.lua`
    - Advanced and better highlighting
    - a
- [nvim-compe](https://github.com/hrsh7th/nvim-compe) - `lua/completion/lua.lua`
    - Amazing and best completion and suggestion to integration with LSP
    - a
- [lspkind-nvim](https://github.com/onsails/lspkind-nvim) - `init.lua` on the line 72
    - This tiny plugin adds vscode-like pictograms to neovim built-in lsp
    - a
- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) - `snippets/*`
    - VSCode(LSP)'s snippet feature in vim
    - a
- [vim-vsnip-integ](https://github.com/hrsh7th/vim-vsnip-integ) - `Not have configuration File`
    - To best integration of `vim-vsnip` with any completion-engine
    - a
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - `lua/lsp/*`
    - A collection of common configurations for Neovim LSP
    - a
- [flutter-tools](https://github.com/akinsho/flutter-tools.nvim) - `Not have configuration File`
    - Build flutter and dart applications in neovim using the native lsp
    - a
- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim) - `Not have configuration File`
    - Extra rust tools for writing applications in neovim using the native lsp
    - a
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - `lua/gitsigns/lua.lua`
    - For integration with Git (Show Changes on line numbers and show commits conceal on each line)
    - a
- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) - `lua/lualine/lua.lua`
    - A blazing fast and easy to configure neovim statusline written in pure lua
    - a
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - `Not have configuration File`
    - A super powerful autopairs for Neovim
    - a
- [vim-closetag](https://github.com/alvan/vim-closetag) - `Not have configuration File`
    - a
- [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua) - `Not have configuration File`
    - File navigation written in pure lua
    - a
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - `Not have configuration File`
    - This plugin provides the same icons as well as colors for each icon.
    - a
- [vim-devicons](https://github.com/ryanoasis/vim-devicons) - `Not have configuration File`
    - a
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - `Not have configuration File`
    - Is a highly extendable fuzzy finder over lists
    - a
- [telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim) - `Not have configuration File`
    - Required for show Media Files (png, jpg, etc) with telescope
    - a
- [presence.nvim](https://github.com/andweeb/presence.nvim) - `Not have configuration File`
    - Discord Rich Presence for Neovim
    - a
- [surround.nvim](https://github.com/blackCauldron7/surround.nvim) - `Not have configuration File`
    - A surround text object plugin for neovim written in lua
    - a
- [instant.nvim](https://github.com/jbyuki/instant.nvim) - `Not have configuration File`
    - Collaborative editing in Neovim using built-in capabilities
    - a
- [kommentary](https://github.com/b3nj5m1n/kommentary) - `Not have configuration File`
    - Neovim commenting plugin, written in lua
    - a

## TODO
- [ ] Add my plugin for take screenshot
- [ ] Add Amazing tab
- [ ] Allow only one instance of Nvim
