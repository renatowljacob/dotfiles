local wezterm = require("wezterm")
local config = {}

local fonts = { "JetBrainsMono Nerd Font", "Iosevka Nerd Font", "FiraCode Nerd Font" }
local font = fonts[1]

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

if font == fonts[1] or font == fonts[3] then
	config.font_size = 13
elseif font == fonts[2] then
	config.font_size = 14
end

config.color_scheme = "tokyonight"
config.enable_tab_bar = false
config.window_background_opacity = 0.97

config.scrollback_lines = 10000

config.disable_default_key_bindings = true
config.keys = {
	{ key = "Enter", mods = "SUPER|CTRL", action = wezterm.action.SpawnWindow },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
}

return config
