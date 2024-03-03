local api = vim.api
--local autocmd = api.nvim_create_autocmd

--[[ require("typescript").setup({
	server = {
		on_attach = function()
			require("keymaps").lsp()
		end
	},
}); ]]
local M = {}

local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local function attach()
  vim.keymap.set('n', '<leader>tt', function()
    local cmds = api.nvim_get_commands { builtin = false }
    cmds = vim.tbl_filter(function(cmd)
      return vim.startswith(cmd.name, 'TSTools')
    end, cmds)

    cmds = vim.tbl_map(function(cmd)
      return cmd.name
    end, cmds)

    local opts = {
      require('telescope.themes').get_dropdown {},
    }
    local buf = api.nvim_get_current_buf()
    require('telescope.pickers')
      .new(opts, {
        prompt_title = 'TSTools',
        finder = require('telescope.finders').new_table {
          results = cmds,
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            if selection == nil then
              return
            end

            actions.close(prompt_bufnr)
            local val = selection.value
            local cmd = string.format([[:%s ]], val)

            if val.nargs == '0' then
              local cr = vim.api.nvim_replace_termcodes('<cr>', true, false, true)
              cmd = cmd .. cr
            end
            vim.cmd [[stopinsert]]
            vim.api.nvim_feedkeys(cmd, 't', false)
          end)

          return true
        end,
      })
      :find()
  end, { desc = 'telescope TSTOOLS' })
end

function M.setup()
  require('typescript-tools').setup {
    server = {
      on_attach = function()
        require('keymaps').lsp()
        attach()
      end,
    },
  }
end

return M
