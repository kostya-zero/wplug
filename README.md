# wplug
A minimal plugin manager for WezTerm written in pure Lua.

## Installation 
`wplug` uses the `.wezterm` directory in your home directory to store itself and all your plugins.
Run this line in the terminal to install `wplug`:

```shell
mkdir ~/.wezterm && git clone --branch main https://gitlab.com/kostya-zero/wplug.git -- ~/.wezterm/wplug
```

This will also allow `wplug` to be updated along with your plugins.

## Configuration
To use `wplug` you need to get his module in your configuration file and call method `setup` with options options.
```lua
local wplug = require("wplug")
wplug.setup({
    -- Field with your plugins
    spec = {

        -- Update wplug too!
        {
            "kostya-zero/wplug",
            provider = "https://gitlab.com",
            branch = "main",
        },

        -- Example
        {
            "user/awesome-plugin"
        },

        -- If plugin installed locally
        {
            "/path/to/local/plugin",

            -- Required
            local_install = true
        }
    },

    -- Configuration for wplug.
    config = {
        -- Nothing to fill here at this moment.
    }
})

```

Here's the table of options that you can set for plugins.

| Field         | Description                                                                                         | Type     |
| -----         | --                                                                                                  | -------- |
| `[1]`         | Path to plugin that stored local or `username/repository_name`.                                     | `string` |
| provider      | URL header where plugin will be cloned from (git repositories only). Example: `https://github.com`  | `string` |
| branch        | Branch to use when cloning repository.                                                              | `string` |
| name          | Name for plugin directory. If it's empty, `wplug` automatically choose name for it.                 | `string` |
| local_install | Is this plugin installed localy or not. Will be fixed soon.                                         | `bool`   |


## For developers of plugins
`wplug` exetends `package.path` to provide developers more options to structure their plugins by adding new Lua scan paths.

For example, we are call `require("foo")` and Lua will look for module in default and new locations:

- `.wezterm/foo/init.lua`
- `.wezterm/foo/foo.lua`
- `.wezterm/foo/lua/init.lua`
- `.wezterm/foo/lua/foo.lua`

## Methods in `wplug`

#### `wplug.setup(opts)`

Method to setup plugins and `wplug`.

#### `wplug.update()`

Updates all installed plugins.

#### `wplug.count()`

Returns number of installed plugins.

#### `wplug.version()`

Returns version of `wplug`.

