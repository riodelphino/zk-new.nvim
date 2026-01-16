# zk-new.nvim

An extension for [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim) that provides interactive selection for creating new notes.

Based on the ZK config:
- groups
- paths
- templates

> [!Note]
> When [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim) implements `zk.config` API function, this repository might be integrated to it.
> See [zk-org/zk#484](https://github.com/zk-org/zk/pull/484)


## Requirements

- [zk-org/zk](https://github.com/zk-org/zk)
- [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim)
- [LebJe/toml.lua](https://github.com/LebJe/toml.lua) (luarocks)


## Installation

Install [LebJe/toml.lua](https://github.com/LebJe/toml.lua):
```bash
luarocks install toml
```

Via [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "riodelphino/zk-new.nvim",
  dependencies = { "zk-org/zk-nvim" },
  opts = {},
}
```

## Config

There is no config.


## Usage

Via vim command:
```vim
:ZkNewIntaractive
```

Via lua function:
```lua
-- Interactively select group, path, and template to create a new note:
require("zk_new").new_interactive()

-- Interactively select, then execute callback:
require("zk_new").new_interactive(
  ---@param options table? A table includes .group, .dir and .template fields. (Also includes ZK options)
  ---@param toml table?    A config table fetched from ZK `config.toml`.
  function(options, toml)
    -- Do something based on the selected group, dir, and template.
  end
)

```
> [!Note]
> `.path` is renamed to `.dir` in options, to avoid confusion with `.notebook_path`. 


## Issue

- [ ] Searching `config.toml` logic is still incorrect in some cases:
   - [ ] See [tjex's comment on Github](https://github.com/zk-org/zk-nvim/pull/268/files#r2591800149)
   - [ ] Fixing it temporary:
      - [ ] If it is ZK notebook dir, find `.zk/config.toml`.
      - [ ] If not, find it in `$XDG_CONFIG_HOME` dir.


## License

MIT license. See [LICENSE](LICENSE)


## Related

- [zk-org/zk](https://github.com/zk-org/zk)
- [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim)
- [riodelphino/zk-buf-cache.nvim](https://github.com/riodelphino/zk-buf-cache.nvim)
- [riodelphino/zk-bufferline.nvim](https://github.com/riodelphino/zk-bufferline.nvim)

