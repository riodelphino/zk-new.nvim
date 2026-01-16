local core = require("zk_new.core")

---Update zk cache on save and read
vim.api.nvim_create_user_command("ZkNewIntaractive", function(options)
  options = options or {}
  core.new_interactive(options, function(_options, _)
    require("zk").new(_options)
  end)
end, {})
