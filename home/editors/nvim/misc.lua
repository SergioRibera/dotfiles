-- Custom show keymaps
local telescope_finders = require "telescope.finders"
local telescope_pickers = require "telescope.pickers"
local telescope_config = require("telescope.config").values
local telescope_entry_display = require('telescope.pickers.entry_display')
local floating_win = nil
local floating_buf = nil

function _G.close_floating()
  if floating_win and vim.api.nvim_win_is_valid(floating_win) then
    vim.api.nvim_win_close(floating_win, true)
    floating_win = nil
    floating_buf = nil
    return
  end
end

function _G.toggle_floating(cmd, opts)
  close_floating()
  local w = opts and opts.width or 0.7
  local h = opts and opts.height or 0.7
  local width = math.floor(vim.o.columns * w)
  local height = math.floor(vim.o.lines * h)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  floating_buf = vim.api.nvim_create_buf(false, true)

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded'
  }

  floating_win = vim.api.nvim_open_win(floating_buf, true, opts)

  vim.api.nvim_buf_set_name(floating_buf, 'command-floating')
  vim.api.nvim_set_option_value('filetype', cmd[0] or cmd, { buf = floating_buf })
  -- vim.api.nvim_set_option_value('buftype', 'terminal', { win = floating_win })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = floating_buf })

  if opts and opts.exit_with_scape then
    vim.api.nvim_buf_set_keymap(floating_buf, 't', '<Esc>', '<C-\\><C-n>:lua _G.close_floating()<CR>',
      {noremap = true, silent = true})
  end

  vim.api.nvim_buf_set_keymap(floating_buf, 'n', 'q', ':lua _G.close_floating()<CR>',
    {noremap = true, silent = true})

  vim.fn.termopen(cmd, {
    cwd = vim.fn.getcwd(),
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        close_floating()
      end
    end
  })

  vim.cmd('startinsert')
end

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
