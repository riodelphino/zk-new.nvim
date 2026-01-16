local M = {}

---@param user_opts table?
function M.setup(user_opts)
  -- local config = require("zk_new.config") -- NOTE: for future use
  -- config.options = vim.tbl_deep_extend("force", config.options, user_opts)
  require("zk_new.commands")
end

return M
