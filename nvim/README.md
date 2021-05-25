# Nvim Dotfiles
I'll keep adding new features like snippets etc and clean the config , make neovim (cli version) as functional as an IDE . Pull requests are welcome.

## Screenshots
## General
![Screenshot_20210521_015354](https://user-images.githubusercontent.com/56278796/119463249-9496c500-bd0f-11eb-8ca8-329b1abe2d2b.png)
---
![Screenshot_20210525_020029](https://user-images.githubusercontent.com/56278796/119463269-9a8ca600-bd0f-11eb-9970-e72aeb3f1e12.png)

## **Features**
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

## **Cycle Theme System**
This is a custom system with autoload on open Nvim, this load last theme selected
    <details><summary>Material</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463355-b132fd00-bd0f-11eb-9ff4-45b2ff30973d.png"></details>
    <details><summary>One Dark (With Background transparent)</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463439-c27c0980-bd0f-11eb-84e0-f7777256cd10.png"></details>
    <details><summary>Nord</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463285-9f515a00-bd0f-11eb-945b-5bef62649b08.png"></details>
> If you want add other theme, i use [nvim-base16](https://github.com/norcalli/nvim-base16.lua) for themes so you can search some themes for add, the next step is modify the `lua/mappings/lua.lua` file on line `16` adding a theme in the list

### Plugins
- [packer](https://github.com/wbthomason/packer.nvim) - `Not have configuration File` but a list of plugins stay on `lua/pluginList/lua.lua`
    - To install plugins natively
- [lspkind-nvim](https://github.com/onsails/lspkind-nvim) - `init.lua` on the line 72
    - This tiny plugin adds vscode-like pictograms to neovim built-in lsp
- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip) - `snippets/*`
    - VSCode(LSP)'s snippet feature in vim
- [vim-vsnip-integ](https://github.com/hrsh7th/vim-vsnip-integ) - `Not have configuration File`
    - To best integration of `vim-vsnip` with any completion-engine
- [flutter-tools](https://github.com/akinsho/flutter-tools.nvim) - `Not have configuration File`
    - Build flutter and dart applications in neovim using the native lsp
- [rust-tools.nvim](https://github.com/simrat39/rust-tools.nvim) - `Not have configuration File`
    - Extra rust tools for writing applications in neovim using the native lsp
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - `Not have configuration File`
    - A super powerful autopairs for Neovim
- [vim-closetag](https://github.com/alvan/vim-closetag) - `Not have configuration File`
- [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - `Not have configuration File`
    - This plugin provides the same icons as well as colors for each icon.
- [vim-devicons](https://github.com/ryanoasis/vim-devicons) - `Not have configuration File`
- [surround.nvim](https://github.com/blackCauldron7/surround.nvim) - `Not have configuration File`
    - A surround text object plugin for neovim written in lua
- [instant.nvim](https://github.com/jbyuki/instant.nvim) - `Not have configuration File`
    - Collaborative editing in Neovim using built-in capabilities
- [kommentary](https://github.com/b3nj5m1n/kommentary) - `Not have configuration File`
    - Neovim commenting plugin, written in lua
- [nvim-base16](https://github.com/norcalli/nvim-base16.lua) - `lua/mappings/lua.lua` to edit themes list
    - Programmatic lua library for setting [base16](https://github.com/chriskempson/base16) themes in Neovim
- [colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - `Not have configuration File`
    - A high-performance color highlighter for Neovim


- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - `init.lua`
    - To amazing ident Lines <br>
    ![Screenshot_20210525_024444](https://user-images.githubusercontent.com/56278796/119464527-ce1c0000-bd10-11eb-87e3-e55887893fc4.png)

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - `lua/treesitter/lua.lua`
    - Advanced and better highlighting <br>![Screenshot_20210525_031035](https://user-images.githubusercontent.com/56278796/119464694-fe639e80-bd10-11eb-8aae-431185699184.png)
- [nvim-compe](https://github.com/hrsh7th/nvim-compe) - `lua/completion/lua.lua`
    - Amazing and best completion and suggestion to integration with LSP <br>![Screenshot_20210525_021720](https://user-images.githubusercontent.com/56278796/119464759-11766e80-bd11-11eb-9603-926c3b1cef80.png)
    - 
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - `lua/lsp/*`
    - A collection of common configurations for Neovim LSP <br>![Screenshot_20210525_021806](https://user-images.githubusercontent.com/56278796/119465024-4c78a200-bd11-11eb-9c61-ea384ce7b7c8.png)

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - `lua/gitsigns/lua.lua`
    - For integration with Git (Show Changes on line numbers and show commits conceal on each line) <br>![Screenshot_20210525_022010](https://user-images.githubusercontent.com/56278796/119465053-53071980-bd11-11eb-840b-9c824c2d3d3c.png)

- [lualine.nvim](https://github.com/hoob3rt/lualine.nvim) - `lua/lualine/lua.lua`
    - A blazing fast and easy to configure neovim statusline written in pure lua <br>![Screenshot_20210525_042905](https://user-images.githubusercontent.com/56278796/119465733-f1937a80-bd11-11eb-855f-449f2dbf9b94.png)

- [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua) - `Not have configuration File`
    - File navigation written in pure lua <br>![Screenshot_20210525_042948](https://user-images.githubusercontent.com/56278796/119465674-e2acc800-bd11-11eb-836d-15476950d97f.png) <br>![Screenshot_20210525_020243](https://user-images.githubusercontent.com/56278796/119463394-ba23ce80-bd0f-11eb-8004-347b0486f10d.png)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - `Not have configuration File`
    - Is a highly extendable fuzzy finder over lists <br>![Screenshot_20210525_021112](https://user-images.githubusercontent.com/56278796/119465116-64502600-bd11-11eb-82b1-b1aeb01cee9e.png) <br>![Screenshot_20210525_022307](https://user-images.githubusercontent.com/56278796/119465817-0708a480-bd12-11eb-846e-789c7846c845.png) <br>![Screenshot_20210525_022335](https://user-images.githubusercontent.com/56278796/119465834-0c65ef00-bd12-11eb-9029-6ac99f2f7bf4.png)

- [telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim) - `Not have configuration File`
    - Required for show Media Files (png, jpg, etc) with telescope <br>![Screenshot_20210525_021520](https://user-images.githubusercontent.com/56278796/119465126-67e3ad00-bd11-11eb-9522-5cf961b8413f.png)

- [presence.nvim](https://github.com/andweeb/presence.nvim) - `Not have configuration File`
    - Discord Rich Presence for Neovim <br>![presence-demo](https://user-images.githubusercontent.com/56278796/119466309-7e3e3880-bd12-11eb-8253-b2033783b84d.gif)

## TODO
- [ ] Add my plugin for take screenshot
- [ ] Add Amazing tab
- [ ] Allow only one instance of Nvim
