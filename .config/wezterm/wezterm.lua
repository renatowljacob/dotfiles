local wezterm = require("wezterm")
local config = {}

local font = "JetBrainsMono Nerd Font"

config.font = wezterm.font_with_fallback({
	{
		family = font,
		harfbuzz_features = { "zero", "ss02", "cv03", "cv04" },
	},
	"Font Awesome 6 Free",
})

config.font_rules = {
	{
		intensity = "Normal",
		italic = false,
		font = wezterm.font({
			family = font,
			weight = "Medium",
			harfbuzz_features = { "zero", "ss02", "cv03", "cv04" },
		}),
	},
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			italic = false,
			weight = "Bold",
			family = font,
			harfbuzz_features = { "zero", "ss02", "cv03", "cv04" },
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			italic = true,
			weight = "Bold",
			family = font,
			harfbuzz_features = { "zero", "ss02", "cv03", "cv04" },
		}),
	},
}
config.font_size = 13

config.color_scheme = "Tokyo Night Storm"
config.enable_tab_bar = false

config.max_fps = 120
config.scrollback_lines = 10000

config.disable_default_key_bindings = true
config.keys = {
	{ key = "Enter", mods = "SUPER|CTRL", action = wezterm.action.SpawnWindow },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

config.warn_about_missing_glyphs = false

return config
