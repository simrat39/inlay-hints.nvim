# inlay-hints.nvim

Neovim support for LSP Inlay Hints

## Prerequisites

- `neovim 0.7+`

## Installation

using `packer.nvim`

```lua
use('simrat39/inlay-hints.nvim')
```

<b>Look at the configuration information below to get started.</b>

## Setup

Put this in your init.lua or any lua file that is sourced.<br>

```lua
require("inlay-hints").setup()
```

## Usage

The plugin hooks itself to the on_attach callback of an LSP Server.

```lua
local ih = require("inlay-hints")
local lspconfig = require("lspconfig")

lspconfig.sumneko_lua.setup({
  on_attach = function(c, b)
    ih.on_attach(c, b)
  end,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
    },
  },
})
```
