local M = {}

---Load and decode 'config.toml'
---@param cwd? string Notebook root directory (optional)
---@return table? config Decoded TOML config if successful
function M.get_config_toml(cwd)
  local ltoml = require("toml")
  cwd = cwd or require("zk.util").notebook_root(vim.fn.getcwd())
  if not cwd then
    return
  end
  toml_path = vim.fs.joinpath(cwd, ".zk/config.toml") -- FIXME: See: https://github.com/zk-org/zk-nvim/pull/268/files#r2591800149
  local result, config = pcall(ltoml.decodeFromFile, toml_path)
  if not result then
    vim.notify("Error: Cannot get 'config.toml'.", vim.log.levels.ERROR, { title = "zk-nvim" })
    return
  end
  return config
end

---Get templates list
---@param cwd string?
---@return table<string, {name:string, path:string, content:string}>? temlates
function M.get_templates(cwd)
  cwd = cwd or require("zk.util").notebook_root(vim.fn.getcwd())
  if not cwd then
    return
  end
  local template_dir = vim.fs.joinpath(cwd, ".zk/templates")
  local paths = vim.fn.globpath(template_dir, "*.md", false, true)
  local templates = {}
  for _, path in ipairs(paths) do
    local template = {
      path = path,
      name = vim.fn.fnamemodify(path, ":t"),
      stem = vim.fn.fnamemodify(path, ":t:r"),
      content = table.concat(vim.fn.readfile(path), "\n"),
    }
    templates[path] = template
  end
  return templates
end

---Get directories list
---@param cwd string?
---@param depth number?
---@param ignores table?
---@return table? directories
function M.get_dirs(cwd, depth, ignores)
  cwd = cwd or require("zk.util").notebook_root(vim.fn.getcwd())
  if not cwd then
    return
  end
  depth = depth or 10
  ignores = ignores or {}
  local dirs = {}
  for name, type in vim.fs.dir(cwd, { depth = depth }) do
    if type == "directory" then
      local segments = vim.split(name, "[/\\]")
      local hidden = false
      local ignored = false
      for _, segment in ipairs(segments) do
        if segment:sub(1, 1) == "." then
          hidden = true
          break
        end
        for _, part in ipairs(ignores) do
          if segment == part then
            ignored = true
            break
          end
        end
      end
      if not hidden and not ignored then
        table.insert(dirs, name)
      end
    end
  end
  return dirs
end

return M
