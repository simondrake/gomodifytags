<div align="center">
  
# gomodifytags

</div>

## Caution
This plug-in is still very much in alpha phase, use at your own risk.

## Pre-requisites
* neovim 0.5.0+
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [gomodifytags](https://github.com/fatih/gomodifytags)

## Installation
* install using your favorite plugin manager ([lazy](https://github.com/folke/lazy.nvim) in this example)

```vim
  {
    'simondrake/gomodifytags',
    dependencies = { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  }
```
## Set-up

Require and call the `setup` function, with optional configuration (see below) - `require('gomodifytags').setup()`.

## Configuration

By passing through an optional table into the `setup()` function, you can set defaults that can be overridden on a per-invocation basis. For example, to change the `transformation` to `snakecase` you would do the following:

```lua
require('gomodifytags').setup({transformation = "camelcase"})`
```

Or directly with the lazy plug-in manager:

```lua
  {
    'simondrake/gomodifytags',
    dependencies = { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    opts = {
      transformation = "camelcase",
      skip_unexported = true,
      override = true,
      options = { "json=omitempty" }
    },
  }
```

The default configuration for this plug-in is below:

```lua
M.config = {
  transformation = "camelcase",
  skip_unexported = true,
  override = true,
  sort = false,
  options = {},
  parse = { enabled = false, seperator = "--" }
}
```

## Running

This plug-in can then be used, with optional overrides, by requiring and calling the `GoAddTags` function

```vim
:lua require('gomodifytags').GoAddTags("json,yaml", {transformation = "snakecase", skip_unexported = false})
```

## Creating a command

Because of how `vim.api.nvim_create_user_command` works, it is not possible to pass through a table and `args` is a string parameter. If you would still like to use a command, this is very experimental and may have some edge cases.

If you would still like to try it out, you will need to set an additional configuration - `parse`. In most cases `seperator` can be kept as the default (`--`) but it is added as a configuration option in case you need to amend it.

```lua
require('gomodifytags').setup({transformation = "camelcase", parse = { enabled = true, seperator = "--" }})`
```

Or directly with the lazy plug-in manager:

```lua
  {
    'simondrake/gomodifytags',
    dependencies = { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    opts = {
      transformation = "camelcase",
      skip_unexported = true,
      override = true,
      options = { "json=omitempty" },
      parse = { enabled = true, seperator = "--" },
    },
  }
```

You can use the following which will create a `GoAddTags` command:

```lua
vim.api.nvim_create_user_command('GoAddTags', function(opts) require('gomodifytags').GoAddTags(opts.fargs[1], opts.args) end, { nargs = "+" })
```

Which can be used with the following format, where `<parse.seperator>` is what is defined in the configuration (`--` by default):

```vim
:GoAddTags "json" <parse.seperator> {transformation = "snakecase", skip_unexported = false}
```
