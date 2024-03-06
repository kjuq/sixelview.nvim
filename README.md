# sixelview.nvim

View images within your Neovim via Sixel!

## Disclaimer

This plugin is in experimental state. So sometimes displayed contents of a buffer break.
When you encounter this issue, type `<C-l>` to reload a screen.

## DEMO

![demo](https://github.com/kjuq/sixelview.nvim/blob/master/img/demo.gif?raw=true)

## Installation

### Lazy.nvim

```lua
{
	"kjuq/sixelview.nvim",
	opts = {},
}
```

After installing this plugin, a image will be shown when a buffer which loads an image file is opened.

## Configuration

```lua
{
	"kjuq/sixelview.nvim",
	opts = {
		-- a table to specify what files should be viewed by this plugin
		pattern = {},
		-- whether to show an image automatically when an image buffer is opened
		auto = true,
		-- time of delay before showing image
		-- try setting this duration longer if you have a trouble showing image
		delay_ms = 100,
	},
}
```

## User Command

### `SixelView`

View image manually. Use this within a buffer which loads an image file.
