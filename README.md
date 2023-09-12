<div align="center">
# gomodifytags
</div>

## Caution
This plug-in is still very much in alpha phase, use at your own risk.

## Installation
* neovim 0.5.0+ required
* [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
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
}
```

## Running

This plug-in can then be used, with optional overrides, by requiring and calling the `GoAddTags` function

```vim
:lua require('gomodifytags').GoAddTags("json,yaml", {transformation = "snakecase", skip_unexported = false})
```
