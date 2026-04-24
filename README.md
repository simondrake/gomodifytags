<div align="center">

# gomodifytags

##### A Neovim plugin for adding and removing struct tags in Go, powered by [gomodifytags](https://github.com/fatih/gomodifytags).

</div>

Place your cursor inside a Go struct and run a command to add or remove tags -- the plugin uses treesitter to detect the struct name automatically.

## Requirements

- Neovim 0.9+
- [gomodifytags](https://github.com/fatih/gomodifytags) installed and on your `$PATH`

## Installation

```lua
-- lazy.nvim
{
  "simondrake/gomodifytags",
  ft = "go",
  opts = {},
}
```

## Configuration

Pass options to `setup()` to set defaults. Every option can also be overridden per-call (see [Usage](#usage)).

```lua
{
  "simondrake/gomodifytags",
  ft = "go",
  opts = {
    transformation = "snakecase",
    skip_unexported = true,
    override = true,
    sort = true,
    options = { "json=omitempty" },
  },
}
```

### Options

| Option | Type | Default | Description |
|---|---|---|---|
| `transformation` | `string` | `"camelcase"` | Tag name casing: `camelcase`, `snakecase`, `lispcase`, `pascalcase`, `titlecase`, `keep` |
| `skip_unexported` | `boolean` | `true` | Skip unexported (lowercase) fields |
| `override` | `boolean` | `true` | Override existing tags instead of skipping them |
| `sort` | `boolean` | `false` | Sort tags alphabetically |
| `options` | `string[]` | `{}` | Tag options (e.g. `{ "json=omitempty", "xml=cdata" }`) |
| `parse` | `table` | `{ enabled = false, separator = "--" }` | Enable string-based argument parsing for user commands (see [User Commands](#user-commands)) |

## Usage

### GoAddTags

Add struct tags. Place your cursor inside a struct and run:

```vim
:lua require('gomodifytags').GoAddTags("json")
```

Add multiple tags at once:

```vim
:lua require('gomodifytags').GoAddTags("json,yaml")
```

Override defaults for a single call:

```vim
:lua require('gomodifytags').GoAddTags("json", { transformation = "snakecase", skip_unexported = false })
```

### GoRemoveTags

Remove struct tags:

```vim
:lua require('gomodifytags').GoRemoveTags("json")
```

Remove multiple tags:

```vim
:lua require('gomodifytags').GoRemoveTags("json,yaml")
```

### Debug

Pass `debug = true` to any call to print the constructed command and intermediate values:

```vim
:lua require('gomodifytags').GoAddTags("json", { debug = true })
```

## Keymaps

```lua
vim.keymap.set("n", "<leader>gat", function()
  require("gomodifytags").GoAddTags("json")
end, { desc = "Add json struct tags" })

vim.keymap.set("n", "<leader>grt", function()
  require("gomodifytags").GoRemoveTags("json")
end, { desc = "Remove json struct tags" })
```

## User Commands

Because `nvim_create_user_command` passes arguments as a single string, passing a Lua table of overrides requires the `parse` option.

Enable it in your config:

```lua
opts = {
  parse = { enabled = true, separator = "--" },
}
```

Then create the commands:

```lua
vim.api.nvim_create_user_command("GoAddTags", function(cmd)
  require("gomodifytags").GoAddTags(cmd.fargs[1], cmd.args)
end, { nargs = "+" })

vim.api.nvim_create_user_command("GoRemoveTags", function(cmd)
  require("gomodifytags").GoRemoveTags(cmd.fargs[1], cmd.args)
end, { nargs = "+" })
```

Usage (where `--` is your configured separator):

```vim
:GoAddTags json -- { transformation = "snakecase" }
:GoRemoveTags yaml
```
