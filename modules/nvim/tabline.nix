{ colors }: ''
local set_hl = hl.set_hl
local gen_hl = hl.gen_hl

local tabline = {}
local fn = vim.fn

tabline.options = {
    show_index = false,
    show_modify = true,
    show_icon = true,
    show_close = false,
    separator = "",
    spacing = "",
    close_icon = "×",
    close_command = "deletebuf !",
    indicators = {
        modify = "•"
    },
    no_name = "[No Name]",
    colors = {
        selected = {
            bg = "${colors.base01}",
            fg = "${colors.base0B}"
        },
        disabled = {
            bg = "${colors.base02}",
            fg = "${colors.base03}"
        },
        empty = "${colors.base00}"
    },
}

---Handle a user "command" which can be a string or a function
---@param command string|function
---@param buf_id string
local function handle_user_command(command, buf_id)
    if not command then
        return
    end
    if type(command) == "function" then
        command(buf_id)
    elseif type(command) == "string" then
        vim.cmd(fmt(command, buf_id))
    end
end

function tabline.handle_close_tab(buf_id)
    local options = tabline.options
    local close = options.close_command
    handle_user_command(close, buf_id)
end

---Add click action to a component
function tabline.make_clickable(id, func_name, component)
    return "%" .. id .. "@tabline_lua#" .. func_name .. "@" .. component
end

function tabline.get_icon(name, extension, selected, opts)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if ok then
        local icon, icon_hgroup = devicons.get_icon(name, extension)
        if icon then
            local new_icon_hgroup = "TabLine" .. icon_hgroup
            if selected then
                new_icon_hgroup = "TabLineSelect" .. icon_hgroup
            end
            return gen_hl(icon_hgroup, new_icon_hgroup, selected, opts, icon)
        end
        return ""
    else
        ok = vim.fn.exists("*WebDevIconsGetFileTypeSymbol")
        if ok ~= 0 then
            return vim.fn.WebDevIconsGetFileTypeSymbol() .. " "
        end
    end
    return ""
end

function tabline.set_tabline_hl()
    set_hl("TabLine", {
        bg = tabline.options.colors.disabled.bg,
        fg = tabline.options.colors.disabled.fg
    }) -- No Selected
    set_hl("TabLineSel", {
        bg = tabline.options.colors.selected.bg,
        fg = tabline.options.colors.selected.fg
    }) -- Selected
    -- Separator
    set_hl("TabLineSep", {
        bg = tabline.options.colors.disabled.bg,
        fg = tabline.options.colors.disabled.bg
    }) -- No Selected
    set_hl("TabLineSepSel", {
        bg = tabline.options.colors.disabled.bg,
        fg = tabline.options.colors.selected.bg
    }) -- Selected
    set_hl("TabLineSepNextSel", {
        bg = tabline.options.colors.selected.bg,
        fg = tabline.options.colors.disabled.bg
    }) -- Next is Selected
    set_hl("TabLineSepEnd", {
        bg = tabline.options.colors.empty,
        fg = tabline.options.colors.disabled.bg
    }) -- End
    set_hl("TabLineSepEndSel", {
        bg = tabline.options.colors.empty,
        fg = tabline.options.colors.selected.bg
    }) -- End Selected
    set_hl("TabLineFill", { bg = tabline.options.colors.empty }) -- Fill Empty
end

function tabline.render()
    local s = ""
    for index = 1, fn.tabpagenr("$") do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, "&mod")
        local gengroup = "%#TabLine#"
        local separatorgroup = "%#TabLineSep#"

        s = s .. "%" .. index .. "T"
        if index == fn.tabpagenr() then -- Current is selected
            gengroup = "%#TabLineSel#"
            if index == fn.tabpagenr("$") then
                separatorgroup = "%#TabLineSepEndSel#"
            else
                separatorgroup = "%#TabLineSepSel#"
            end
            -- TODO: made color border on multiple case
        elseif (index + 1) == fn.tabpagenr() then -- Next is selected
            separatorgroup = "%#TabLineSepNextSel#"
        elseif index == fn.tabpagenr("$") then
            separatorgroup = "%#TabLineSepEnd#"
        else -- Not Selected
            separatorgroup = "%#TabLineSep#"
        end

        s = s .. gengroup
        -- tab index
        if tabline.options.show_index then
            s = s .. index
        end
        s = s .. " "
        if tabline.options.show_icon then
            s = s ..
                tabline.get_icon(fn.fnamemodify(bufname, ":e"), fn.fnamemodify(bufname, ":e"), index == fn.tabpagenr(), tabline.options)
                .. gengroup .. " "
        end
        -- buf name
        if bufname ~= "" then
            s = s .. fn.fnamemodify(bufname, ":t")
        else
            s = s .. tabline.options.no_name
        end

        -- modification indicator
        if tabline.options.show_modify and bufmodified == 1 then
            s = s .. " " .. tabline.options.indicators.modify .. " "
        end
        if tabline.options.show_close then
            s = s ..
                tabline.make_clickable(index, "handle_close_tab", gengroup .. tabline.options.close_icon .. tabline.options.spacing .. "%X")
        end
        s = s .. tabline.options.spacing

        s = s .. separatorgroup .. tabline.options.separator .. gengroup .. tabline.options.spacing
    end

    s = s .. "%#TabLineFill#"
    return s
end

tabline.set_tabline_hl()
function _G.s4rch_tabline()
    return tabline.render()
end

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.s4rch_tabline()"

vim.g.loaded_s4rch_tabline = 1
''
