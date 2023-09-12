local ts_utils = require 'nvim-treesitter.ts_utils'
local config = require("gomodifytags.config")

local M = {}


local function get_struct_name()
  local current_node = ts_utils.get_node_at_cursor()

  if not current_node then return "" end

  local expr = current_node

  while expr do
    if expr:type() == 'type_declaration' then
      break
    end
    expr = expr:parent()
  end

  if not expr then return "" end

  local struct_name = ''

  for line in vim.treesitter.get_node_text(expr:child(1), 0):gmatch("([^\n]*)\n?") do
    if string.find(line, "struct {") then
      struct_name = string.gsub(line, "struct {", "")
      break
    end
  end

  return struct_name
end

local function get_value_or_default(opt, global, default)
  if not opt == nil then
    return opt
  elseif not global == nil then
    return global
  else
    return default
  end
end

function M.GoAddTags(tag_name, opts)
  opts = opts or {}

  local filename = vim.fn.expand('%p')
  local struct_name = get_struct_name()

  local transformation = get_value_or_default(opts.transformation, config.config.transformation, "camelcase")
  local skip_unexported = get_value_or_default(opts.skip_unexported, config.config.skip_unexported, false)
  local override = get_value_or_default(opts.override, config.config.override, false)
  local sort = get_value_or_default(opts.sort, config.config.sort, false)
  local options = get_value_or_default(opts.options, config.config.options, false)

  local query = 'gomodifytags -file ' ..
      filename .. ' -struct ' .. struct_name .. ' -w -add-tags ' .. tag_name .. ' -transform ' .. transformation

  if skip_unexported then
    query = query .. ' --skip-unexported '
  end

  if override then
    query = query .. ' -override '
  end

  if sort then
    query = query .. ' -sort '
  end

  if options then
    query = query .. ' -add-options '
    for i, option in ipairs(options) do
      if i == 1 then
        query = query .. option
      else
        query = query .. ',' .. option
      end
    end
  end

  vim.fn.system(query)
  vim.cmd('edit!')
end

function M.setup(user_config)
  user_config = user_config or {}

  require("gomodifytags.config").setup(user_config)
end

return M
