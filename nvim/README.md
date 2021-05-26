# Nvim Dotfiles
I'll keep adding new features like snippets etc and clean the config , make neovim (cli version) as functional as an IDE . Pull requests are welcome.

## Screenshots  General
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

<hr>

## **Cycle Theme System**
This is a custom system with autoload on open Nvim, this load last theme selected
    <details><summary>Material</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463355-b132fd00-bd0f-11eb-9ff4-45b2ff30973d.png"></details>
    <details><summary>One Dark (With Background transparent)</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463439-c27c0980-bd0f-11eb-84e0-f7777256cd10.png"></details>
    <details><summary>Nord</summary><br><img src="https://user-images.githubusercontent.com/56278796/119463285-9f515a00-bd0f-11eb-945b-5bef62649b08.png"></details>
> If you want add other theme, i use [nvim-base16](https://github.com/norcalli/nvim-base16.lua) for themes so you can search some themes for add, the next step is modify the `lua/mappings/lua.lua` file on line `16` adding a theme in the list

## Plugins
<details>
    <summary>
        <a href="https://github.com/wbthomason/packer.nvim">packer</a> <code>Not have configuration File</code> but a list of plugins stay on <code>lua/pluginList/lua.lua</code>
    </summary><br>
    <blockquote>
        <p>To install plugins natively</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/onsails/lspkind-nvim">lspkind-nvim</a> <code>init.lua</code> on the line 72 
    </summary><br>
    <blockquote>
        <p>This tiny plugin adds vscode-like pictograms to neovim built-in lsp</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/hrsh7th/vim-vsnip">vim-vsnip</a> <code>snippets/*</code> 
    </summary><br>
    <blockquote>
        <p>VSCode(LSP)'s snippet feature in vim</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/hrsh7th/vim-vsnip-integ">vim-vsnip-integ</a> <code>Not have configuration File</code> 
    </summary><br>
    <blockquote>
        <p>To best integration of <code>vim-vsnip</code> with any completion-engine</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/akinsho/flutter-tools.nvim">flutter-tools</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> Build flutter and dart applications in neovim using the native lsp</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/simrat39/rust-tools.nvim">rust-tools.nvim</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>Extra rust tools for writing applications in neovim using the native lsp</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/windwp/nvim-autopairs">nvim-autopairs</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>A super powerful autopairs for Neovim</p>
    </blackquote>
</details>
<a href="https://github.com/alvan/vim-closetag">vim-closetag</a> <code>Not have configuration File</code>
<details>
    <summary>
        <a href="https://github.com/kyazdani42/nvim-web-devicons">nvim-web-devicons</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> This plugin provides the same icons as well as colors for each icon.</p>
    </blackquote>
</details>
<a href="https://github.com/ryanoasis/vim-devicons">vim-devicons</a> <code>Not have configuration File</code>
<details>
    <summary>
        <a href="https://github.com/blackCauldron7/surround.nvim">surround.nvim</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> A surround text object plugin for neovim written in lua</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/jbyuki/instant.nvim">instant.nvim</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> Collaborative editing in Neovim using built-in capabilities</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/b3nj5m1n/kommentary">kommentary</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> Neovim commenting plugin, written in lua</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/norcalli/nvim-base16.lua">nvim-base16</a> <code>lua/mappings/lua.lua</code> to edit themes list
    </summary><br>
    <blockquote>
        <p> Programmatic lua library for setting [base16](https://github.com/chriskempson/base16) themes in Neovim</p>
    </blackquote>
</details>
<details>
    <summary>
        <a href="https://github.com/norcalli/nvim-colorizer.lua">colorizer.lua</a> <code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p> A high-performance color highlighter for Neovim</p>
    </blackquote>
</details>

<details>
    <summary>
        <a href="https://github.com/lukas-reineke/indent-blankline.nvim">indent-blankline.nvim</a> <code>init.lua</code>
    </summary><br>
    <blockquote>
        <p>To amazing ident Lines </p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119464527-ce1c0000-bd10-11eb-87e3-e55887893fc4.png">
</details>
<details>
    <summary>
        <a href="https://github.com/nvim-treesitter/nvim-treesitter">nvim-treesitter</a><code>lua/treesitter/lua.lua</code>
    </summary><br>
    <blockquote>
        <p>Advanced and better highlighting</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119464694-fe639e80-bd10-11eb-8aae-431185699184.png">
</details>
<details>
    <summary>
        <a href="https://github.com/hrsh7th/nvim-compe">nvim-compe</a><code>lua/completion/lua.lua</code>
    </summary><br>
    <blockquote>
        <p>Amazing and best completion and suggestion to integration with LSP</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119464759-11766e80-bd11-11eb-9603-926c3b1cef80.png">
</details>
<details>
    <summary>
        <a href="https://github.com/neovim/nvim-lspconfig">nvim-lspconfig</a><code>lua/lsp/*</code>
    </summary><br>
    <blockquote>
        <p>A collection of common configurations for Neovim LSP</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465024-4c78a200-bd11-11eb-9c61-ea384ce7b7c8.png">
</details>
<details>
    <summary>
        <a href="https://github.com/lewis6991/gitsigns.nvim">gitsigns.nvim</a><code>lua/gitsigns/lua.lua</code>
    </summary><br>
    <blockquote>
        <p>For integration with Git (Show Changes on line numbers and show commits conceal on each line)</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465053-53071980-bd11-11eb-840b-9c824c2d3d3c.png">
</details>
<details>
    <summary>
        <a href="https://github.com/hoob3rt/lualine.nvim">lualine.nvim</a><code>lua/lualine/lua.lua</code>
    </summary><br>
    <blockquote>
        <p>A blazing fast and easy to configure neovim statusline written in pure lua</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465733-f1937a80-bd11-11eb-855f-449f2dbf9b94.png">
</details>
<details>
    <summary>
        <a href="https://github.com/kyazdani42/nvim-tree.lua">nvim-tree.lua</a><code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>File navigation written in pure lua</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465674-e2acc800-bd11-11eb-836d-15476950d97f.png)"><br>
    <img src="https://user-images.githubusercontent.com/56278796/119463394-ba23ce80-bd0f-11eb-8004-347b0486f10d.png"><br>
</details>
<details>
    <summary>
        <a href="https://github.com/nvim-telescope/telescope.nvim">telescope.nvim</a><code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>Is a highly extendable fuzzy finder over lists</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465116-64502600-bd11-11eb-82b1-b1aeb01cee9e.png"><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465817-0708a480-bd12-11eb-846e-789c7846c845.png"><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465834-0c65ef00-bd12-11eb-9029-6ac99f2f7bf4.png"><br>
</details>
<details>
    <summary>
        <a href="https://github.com/nvim-telescope/telescope-media-files.nvim">telescope-media-files.nvim</a><code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>Required for show Media Files (png, jpg, etc) with telescope</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119465126-67e3ad00-bd11-11eb-9522-5cf961b8413f.png">
</details>
<details>
    <summary>
        <a href="https://github.com/andweeb/presence.nvim">presence.nvim</a><code>Not have configuration File</code>
    </summary><br>
    <blockquote>
        <p>Discord Rich Presence for Neovim</p>
    </blackquote><br>
    <img src="https://user-images.githubusercontent.com/56278796/119466309-7e3e3880-bd12-11eb-8253-b2033783b84d.gif">
</details>

<hr>

## Mappings
The `leader` is a `Space` key.<br>
The cell empty is equals to up cell. If you want modify any mapping, you can edit the file specified into table for each case.
The modes in my keymapping:
- i = Insert
- s = Select
- n = Normal
- v = Visual
- NerdTree = Being on NerdTree buffer

|   **MODE**   |         **KEYMAP**        |                             **DESCRIPTION**                            |      **FILE TO MODIFY**      |
|:--------:|:---------------------:|:------------------------------------------------------------------:|:------------------------:|
|   i, s   |         `Tab`         |                     Next option into completion                    | `lua/completion/lua.lua` |
|   i, s   |     `Shift + Tab`     |                     Last Option into completion                    |                          |
|     n    |          `ga`         |         Show LSP Code Actios in Telescope (If are aviables)        |    `lua/lsp/init.lua`    |
|     n    |          `gd`         |                    Show Definitions in Telescope                   |                          |
|     n    |      `Shift + k`      |                           Show LSP Hover                           |                          |
|     n    |          `gi`         |                 Show implementations with Telescope                |                          |
|     n    |       `Ctrl + k`      |                       Show LSP signature help                      |                          |
|     n    |          `wa`         |                     Add workspace folder to LSP                    |                          |
|     n    |          `wr`         |                   Remove workspace folder to LSP                   |                          |
|     n    |          `wl`         |                     Show all workspace folders                     |                          |
|     n    |          `rn`         |                         Rename var or text                         |                          |
|     n    |          `gr`         |                   Show references with Telescope                   |                          |
|     n    |          `e`          |                      Show LSP line diagnostics                     |                          |
|     n    |          `q`          |                     Show loclist with Telescope                    |                          |
|     n    |     `leader + tn`     |                          Cycle Teme color                          |  `lua/mappings/lua.lua`  |
|     n    |       `Ctrl + h`      |                        Move to previous tab                        |                          |
|     n    |       `Ctrl + l`      |                          Move to next tab                          |                          |
|     n    |      `leader + y`     |          Copy selected text into clipboard (not only nvim)         |                          |
|     n    |      `leader + p`     |                     Paste any text on clipboard                    |                          |
|     n    |     `leader + ws`     |                         Open Split windows                         |                          |
|     n    |     `leader + wh`     |                     Open Vertical Split windows                    |                          |
|     v    |     `leader + ps`     |       Take Screenshot of selected text (Not implemented yet)       |                          |
|     n    |      `leader + r`     |                          Refresh NvimTree                          |                          |
|     n    |     `leader + cc`     |                       Comment only line stay                       |                          |
|     n    |      `leader + c`     |                 Comment motion default (Kommentary)                |                          |
|     v    |      `leader + c`     |                       Comment selected lines                       |                          |
|     n    |      `leader + q`     |                Quit of buffer (equals to exec `:q`)                |                          |
|     n    |      `leader + w`     |        Save changes on current buffer (equals to exec `:w`)        |                          |
|     n    |     `leader + wq`     |              Save changes on current buffer and close              |                          |
|     n    |       `Ctrl + x`      | Open terminal on bottom of the current buffer with size of 10 rows |                          |
|     n    |      `leader + n`     |                           Toggle NvimTree                          |  `lua/nvimTree/lua.lua`  |
| NerdTree | `o` or `Double Click` |                   Open file or toggle drop folder                  |                          |
| NerdTree |          `v`          |                       Open in vertical split                       |                          |
| NerdTree |          `s`          |                      Open in horizontal split                      |                          |
| NerdTree |          `t`          |                           Open in new Tab                          |                          |
| NerdTree |          `I`          |                        Toggle ignored files                        |                          |
| NerdTree |          `a`          |              Create new file (with folder if necesary)             |                          |
| NerdTree |          `d`          |            Delete file or folder (request confirmation)            |                          |
| NerdTree |          `r`          |                        Rename File or folder                       |                          |
| NerdTree |          `x`          |                         Cut folder or file                         |                          |
| NerdTree |          `c`          |                         Copy folder o file                         |                          |
| NerdTree |          `p`          |                Paste copied or cuted file or folder                |                          |
| NerdTree |          `-`          |                         Go to directory up                         |                          |
| NerdTree |          `q`          |                           Close NvimTree                           |                          |
|     n    |     `leader + ff`     |                      Find Files with Telescope                     |  `lua/telescope/lua.lua` |
|     n    |     `leader + fp`     |             Find and Preview Media Files with Telescope            |                          |
|     n    |     `leader + gc`     |                   Show Git Commits with Telescope                  |                          |
|     n    |     `leader + gb`     |                  Show Git Branches with Telescope                  |                          |
|     n    |     `leader + gs`     |                   Show Git Status with Telescope                   |                          |
|     n    |     `leader + gt`     |                    Show Git Stash with Telescope                   |                          |

# TODO
- [ ] Add Multicursor support
- [ ] Add my plugin for take screenshot
- [ ] Add Amazing tab
- [ ] Allow only one instance of Nvim
