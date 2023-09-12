local M = {}

M.config = {
  transformation = "camelcase",
  skip_unexported = true,
  override = true,
  sort = false,
  options = {},
}

-- TODO actually check the config
local function check_config(_)
  local err
  return not err
end

function M.setup(config)
  if check_config(config) then
    M.config = vim.tbl_deep_extend("force", M.config, config or {})
  else
    vim.notify("Errors found while loading user config. Using default config.", vim.log.levels.ERROR)
  end
end

return M
