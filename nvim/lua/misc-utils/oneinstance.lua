local smanager = require('misc-utils.settings')
smanager.load_settings()

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
local function getos()
        -- Unix, Linux varients
        local fh,err = io.popen("uname -o 2>/dev/null","r")
        if fh then
                osname = fh:read()
                end
        if osname then return osname end
        -- Add code for other operating systems here
        return "Windows"
end

pathTemp = "/tmp"
if getos() == "Windows" then
    pathTemp = "C:\\Windows\\Temp"
end
local one_instance_enable = smanager.get_value("one_instance", false)
if one_instance_enable == true then
    for dir in io.popen([[dir pathTemp /b /ad]]):lines() do
        if string.starts(dir, "nvim") then
            vim.api.nvim_buf_attach()
        end
    end
end
