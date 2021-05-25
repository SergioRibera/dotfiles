-- check if packer is installed (~/local/share/nvim/site/pack)
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
local packer = require("packer")
local use = packer.use

-- using { } when using a different branch of the plugin or loading the plugin with certain commands
return require("packer").startup(
    function()
        use {"wbthomason/packer.nvim", opt = true}
        use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}

        -- color related stuff
        use "norcalli/nvim-base16.lua"
        use "norcalli/nvim-colorizer.lua"

        -- lsp stuff
        use "nvim-treesitter/nvim-treesitter"
        use "hrsh7th/nvim-compe"
        use "onsails/lspkind-nvim"
        use 'hrsh7th/vim-vsnip'
        use 'hrsh7th/vim-vsnip-integ'
        use 'neovim/nvim-lspconfig'
        -- Languajes Independents
        use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}
        use 'simrat39/rust-tools.nvim'

        use "lewis6991/gitsigns.nvim"
        use "akinsho/nvim-bufferline.lua"
        -- use "glepnir/lualine.nvim"
        use { 'hoob3rt/lualine.nvim' }
        use "windwp/nvim-autopairs"
        use "alvan/vim-closetag"

        -- file managing , picker etc
        use "kyazdani42/nvim-tree.lua"
        use "kyazdani42/nvim-web-devicons"
        use "ryanoasis/vim-devicons"
        use "nvim-telescope/telescope.nvim"
        use "nvim-telescope/telescope-media-files.nvim"
        use "nvim-lua/popup.nvim"

        -- misc
        use 'andweeb/presence.nvim' -- display nvim on discord
        use "blackCauldron7/surround.nvim"
        use 'jbyuki/instant.nvim' -- Collaborative Nvim
        use 'b3nj5m1n/kommentary' -- Comment Text
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
    )
