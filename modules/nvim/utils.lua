local utils = {}

function utils.dump_table(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. utils.dump_table(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function utils.get_hex(opts)
    local name, attribute, fallback, not_match =
    opts.name, opts.attribute, opts.fallback, opts.not_match
    -- translate from internal part to hl part
    assert(
        attribute == "fg" or attribute == "bg",
        string.format('Color part for %s should be one of "fg" or "bg"', vim.inspect(opts))
    )
    attribute = attribute == "fg" and "foreground" or "background"

    -- try and get hl from name
    local success, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if success and hl and hl[attribute] then
        -- convert from decimal color value to hex (e.g. 14257292 => "#D98C8C")
        local hex = "#" .. bit.tohex(hl[attribute], 6)
        if not not_match or not_match ~= hex then
            return hex
        end
    end

    -- basic fallback
    if fallback and type(fallback) == "string" then
        return fallback
    end

    -- bit of recursive fallback logic
    if fallback and type(fallback) == "table" then
        assert(
        fallback.name and fallback.attribute,
        'Fallback should have "name" and "attribute" fields'
        )
        return utils.get_hex(fallback) -- allow chaining
    end

    -- we couldn't resolve the color
    return "NONE"
end

local api = vim.api
---------------------------------------------------------------------------//
-- Highlights
---------------------------------------------------------------------------//
local hl = {}

function hl.hl(item)
  return "%#" .. item .. "#"
end

function hl.set_hl(id, opts)
    vim.api.nvim_set_hl(0, id, opts)
end

function hl.hl_exists(name)
  return vim.fn.hlexists(name) > 0
end

function hl.set_one(name, opts)
  if opts and vim.tbl_count(opts) > 0 then
    local cmd = "highlight! " .. name
    if opts.gui and opts.gui ~= "" then
      cmd = cmd .. " " .. "gui=" .. opts.gui
    end
    if opts.guifg and opts.guifg ~= "" then
      cmd = cmd .. " " .. "guifg=" .. opts.guifg
    end
    if opts.guibg and opts.guibg ~= "" then
      cmd = cmd .. " " .. "guibg=" .. opts.guibg
    end
    if opts.guisp and opts.guisp ~= "" then
      cmd = cmd .. " " .. "guisp=" .. opts.guisp
    end
    -- TODO using api here as it warns of an error if setting highlight fails
    local success, err = pcall(vim.cmd, cmd)
    if not success then
      api.nvim_err_writeln(
        "Failed setting "
          .. name
          .. " highlight, something isn't configured correctly"
          .. "\n"
          .. err
      )
    end
  end
end

--- Map through user colors and convert the keys to highlight names
--- by changing the strings to pascal case and using those for highlight name
--- @param user_colors table
function hl.set_all(user_colors)
  for name, tbl in pairs(user_colors) do
    if not tbl or not tbl.hl_name then
      api.nvim_echo({
        {
          ("Error setting highlight group: no name for %s - %s"):format(name, vim.inspect(tbl)),
          "ErrorMsg",
        },
      }, true, {})
    else
      hl.set_one(tbl.hl_name, tbl)
    end
  end
end

function hl.gen_hl(from, to, selected, opts, text)
    local _guibg = opts.colors.disabled.bg
    local _guifg = utils.get_hex({ name = from, attribute = "fg" })
    if selected then
        _guibg = opts.colors.selected.bg
    end
    hl.set_hl(to, {
        bg = _guibg, fg = _guifg
    })
    return '%#' .. to .. '#' .. text
end
