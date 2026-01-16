local zk_util = require("zk.util")
local M = {}

---Prompt for a new note with groups, paths, templates, and directories selections.
--
---@param options? table
---@param cb fun(options: table?, toml: table?)
function M.new_interactive(options, cb)
  cwd = options and options.notebook_path or zk_util.notebook_root(vim.fn.getcwd())
  if not cwd then
    return
  end
  local toml = zk_util.get_config_toml(cwd) or {}
  local groups = toml.group -- Note that it is named `group` instead of `groups` in config.toml

  ---@param a string
  ---@param b string
  ---@return boolean
  local function sorter(a, b)
    return a < b
  end

  ---@param group_names string[]
  ---@param on_select function
  function select_group(group_names, on_select)
    table.sort(group_names, sorter)
    vim.ui.select(group_names, { prompt = "Select a group" }, function(group_name)
      if not group_name then
        return
      end
      options.group = group_name
      on_select()
    end)
  end

  ---@param on_select function
  function select_directory_fs(on_select)
    local dirs = zk_util.get_dirs(cwd) or {}
    table.insert(dirs, "")
    table.sort(dirs, sorter)
    vim.ui.select(dirs, { prompt = "Select a directory" }, function(dir)
      if not dir then
        return
      end
      options.dir = dir
      on_select()
    end)
  end

  ---@param paths string[]
  ---@param on_select function
  function select_paths(paths, on_select)
    table.sort(paths, sorter)
    if #paths > 1 then
      vim.ui.select(paths, { prompt = "Select a path" }, function(path)
        if not path then
          return
        end
        options.dir = path
        options.template = groups[options.group].note and groups[options.group].note.template
        on_select()
      end)
    elseif #paths == 1 then -- Apply automatically if only one path
      options.dir = paths[1]
      options.template = groups[options.group].note and groups[options.group].note.template
      on_select()
    end
  end

  ---@param on_select function
  function select_template_fs(on_select)
    local templates = zk_util.get_templates(cwd)
    if not templates or vim.tbl_count(templates) == 0 then
      local msg = "Cannot find any templates in `.zk/templates`"
      vim.notify(msg, vim.log.levels.ERROR, { title = "zk-nvim" })
      return
    end

    local template_names = {}
    for _, template in pairs(templates) do
      table.insert(template_names, template.name)
    end
    table.sort(template_names, sorter)
    vim.ui.select(template_names, { prompt = "Select a template" }, function(template_name)
      if not template_name then
        return
      end
      options.template = template_name
      on_select()
    end)
  end

  if groups then -- groups exists
    local group_names = vim.tbl_keys(groups)
    select_group(group_names, function()
      local paths = groups[options.group] and groups[options.group].paths
      if paths then -- paths exists
        select_paths(paths, function()
          local template_name = groups[options.group].note and groups[options.group].note.template
          if template_name then
            options.template = template_name
            cb(options, toml)
          else
            select_template_fs(function()
              cb(options, toml)
            end)
          end
        end)
      else -- paths does not exist
        select_directory_fs(function()
          local template_name = groups[options.group].note and groups[options.group].note.template
          if template_name then
            options.template = template_name
            cb(options, toml)
          else
            select_template_fs(function()
              cb(options, toml)
            end)
          end
        end)
      end
    end)
  else -- groups does not exist
    select_directory_fs(function()
      select_template_fs(function()
        cb(options, toml)
      end)
    end)
  end
end

return M
