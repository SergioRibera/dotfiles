{ user, pkgs, ... }: with pkgs.vimPlugins; {
    plugin = lualine-nvim;
    type = "lua";
    config = if user.cfgType == "complete"
    then builtins.readFile ./lualine.lua
    else ''
require('lualine').setup({
    options = {
        theme = 'gruvbox',
	section_separators = {'<U+E0B4>', '<U+E0B6>'},
	component_separators = {"", ""},
	disabled_filetypes = {'Term'},
	icons_enabled = true,
    },
    sections = {
    	lualine_a = { { 'mode', upper = true } },
    	lualine_b = { { 'branch', icon = '<U+E0A0>' } },
    	lualine_c = {
	    {
	    	'filename',
		icons_enabled = true,
		file_status = true,
		symbols = { modified = ' [+]', readonly = ' [-]' }
	    },
	},
    	lualine_x = {  },
    	lualine_y = {  },
    	lualine_z = { 'progress', 'location' },
    },
    inactive_sections = {
    	lualine_a = {},
    	lualine_b = {},
    	lualine_c = {'filetype'},
    	lualine_x = {'location'},
    	lualine_y = {},
    	lualine_z = {},
    },
})
    '';
}
