{ user, pkgs, ... }: with pkgs.vimPlugins; {
    plugin = nvim-cmp;
    type = "lua";
    config = ''
local cmp = require('cmp')
vim.o.completeopt = "menu,menuone,noselect"
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    sources = {
        { name = 'path' },
        { name = 'cmdline' },
    }
})

vim.cmd("autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }")
    '';
}
