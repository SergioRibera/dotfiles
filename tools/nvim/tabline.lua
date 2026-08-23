local tabline = {}

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

function tabline.get_icon(name, extension, selected)
  local icon, icon_fg = require("nvim-web-devicons").get_icon_color(name, extension)
  if icon and icon_fg then
    local new_hi_group = "TabLine" .. extension
    if selected then
      new_hi_group = "TabLineSelect" .. extension
    end
    if vim.fn.hlexists(new_hi_group) == 0 then
      local bg = selected and vim.api.nvim_get_hl(0, { name = "TabLineSel" }).bg or vim.api.nvim_get_hl(0, { name = "TabLine" }).bg
      vim.api.nvim_set_hl(0, new_hi_group, { bg = bg, fg = icon_fg })
    end
    return '%#' .. new_hi_group .. '#' .. icon
  end
  return ""
end

function _G.custom_tabline()
    local s = ""
    for index = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(index)
        local buflist = vim.fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local bufmodified = vim.fn.getbufvar(bufnr, "&mod")
        local gengroup = "%#TabLine#"
        local separatorgroup = "%#TabLineSep#"

        s = s .. "%" .. index .. "T"
        if index == vim.fn.tabpagenr() then -- Current is selected
            gengroup = "%#TabLineSel#"
            if index == vim.fn.tabpagenr("$") then
                separatorgroup = "%#TabLineSepEndSel#"
            else
                separatorgroup = "%#TabLineSepSel#"
            end
        elseif (index + 1) == vim.fn.tabpagenr() then -- Next is selected
            separatorgroup = "%#TabLineSepNextSel#"
        elseif index == vim.fn.tabpagenr("$") then
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
                tabline.get_icon(vim.fn.fnamemodify(bufname, ":e"), vim.fn.fnamemodify(bufname, ":e"), index == vim.fn.tabpagenr())
                .. gengroup .. " "
        end
        -- buf name
        if bufname ~= "" then
            s = s .. vim.fn.fnamemodify(bufname, ":t")
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
