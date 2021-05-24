local function isempty(s)
    return s == nil or s == ''
end
--
--  Split extension function
--
function lines(str)
    local t = {}
    local function helper(line) table.insert(t, line) return "" end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

--
--  Declare exports
--

local M = {}

M.files_settings_path = require("os").getenv('HOME') .. "/.config/nvim/lua_settings.conf"
M.settings = {}
function M.load_settings()
    local file, err = io.open (M.files_settings_path, "r")
    if file == nil then
        print("Couldn't open file: "..err)
    else
        local content = file:read("*a")
        local lines_arr = lines(content)
        if next(lines_arr) ~= nil then
            for v in pairs(lines_arr) do
                local vv = lines_arr[v]
                if not isempty(vv) then
                    local vn_k, vn_v = string.match(vv, "([^,]+)=([^,]+)")
                    M.settings[vn_k] = vn_v
                end
            end
        end
        file:close()
    end
end
function M.set_value(name, val)
    local file = io.open(M.files_settings_path, "w")
    M.settings[name] = val
    for k, v in pairs(M.settings) do
        file:write(k .. "=" .. v .. "\n")
    end
    file:close()
end
function M.get_value(name, default)
    if M.settings[name] then
        return M.settings[name]
    else
        return default
    end
end

return M
