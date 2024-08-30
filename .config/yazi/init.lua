-- ~/.config/yazi/init.lua

---@diagnostic disable:undefined-global

-- NOTE: relative-motions plugin
require("relative-motions"):setup({ show_numbers = "relative_absolute", show_motion = true, only_motions = true })

-- NOTE: Show file owner in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)

-- NOTE: show username in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name()):fg("magenta"),
		ui.Span(" "),
		ui.Span("in"),
		ui.Span(" "),
	})
end, 500, Header.LEFT)
