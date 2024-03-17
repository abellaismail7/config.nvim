local M = {}

function M.setup()
  vim.g.skip_ts_context_commentstring_module = true

  ---@diagnostic disable-next-line: missing-fields
  require('Comment').setup {
    pre_hook = function()
      local res = require('ts_context_commentstring.internal').calculate_commentstring()
      print(vim.inspect(res))
      if res ~= nil then
        return res
      end
      error 'No comment string found'
    end,
  }
end

return M
