-- Custom show keymaps
local telescope_finders = require "telescope.finders"
local telescope_pickers = require "telescope.pickers"
local telescope_config = require("telescope.config").values
local telescope_entry_display = require('telescope.pickers.entry_display')

function _G.show_my_keymaps(opts)
    local keymaps_table = _G.my_mapping_table

    telescope_pickers.new({
        prompt_title = "My Custom Key Maps",
        finder = telescope_finders.new_table {
            results = keymaps_table,
            entry_maker = function(entry)
                if entry.mode == "i" then
                    entry.mode = "Insert"
                elseif entry.mode == "v" or entry.mode == "x" then
                    entry.mode = "Visual"
                elseif entry.mode == "s" then
                    entry.mode = "Select"
                elseif entry.mode == "n" then
                    entry.mode = "Normal"
                elseif entry.mode == "t" then
                    entry.mode = "Terminal"
                end

                local width = telescope_config.width or telescope_config.layout_config.width or telescope_config.layout_config[telescope_config.layout_strategy].width
                local cols = vim.o.columns
                local tel_win_width
                if width > 1 then
                    tel_win_width = width
                else
                    tel_win_width = math.floor(cols * width)
                end
                local cheatcode_width = math.floor(cols * 0.25)
                local section_width = 15

                -- NOTE: the width calculating logic is not exact, but approx enough
                local displayer = telescope_entry_display.create {
                    separator = " ▏",
                    items = {
                        { width = 7 }, -- mode
                        { width = section_width }, -- category
                        { width = section_width }, -- mapping
                        { width = tel_win_width - cheatcode_width
                                - section_width, }, -- description
                    },
                }

                local function make_display(ent)
                    return displayer {
                        -- text, highlight group
                        { ent.value.mode, "cheatCode" },
                        { ent.value.category, "cheatMetadataSection" },
                        { ent.value.lhs, "cheatMetadataSection" },
                        { ent.value.description, "cheatDescription" },
                    }
                end

                return {
                    value = entry,
                    -- generate the string that user sees as an item
                    display = make_display,
                    -- queries are matched against ordinal
                    ordinal = string.format(
                        '%s %s %s %s', entry.mode, entry.category, entry.lhs, entry.description
                    ),
                }
            end,
        },
        sorter = telescope_config.generic_sorter(opts),
    }):find()
end

