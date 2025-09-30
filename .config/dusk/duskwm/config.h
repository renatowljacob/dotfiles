/* See LICENSE file for copyright and license details. */

/* appearance */
static unsigned int borderpx       = 3;   /* border pixel of windows */
static unsigned int snap           = 32;  /* snap pixel */
static unsigned int gappih         = 6;   /* horiz inner gap between windows */
static unsigned int gappiv         = 6;   /* vert inner gap between windows */
static unsigned int gappoh         = 6;   /* horiz outer gap between windows and screen edge */
static unsigned int gappov         = 6;   /* vert outer gap between windows and screen edge */
static unsigned int gappfl         = 6;   /* gap between floating windows (when relevant) */
static unsigned int smartgaps_fact = 0;   /* smartgaps factor when there is only one client; 0 = no gaps, 3 = 3x outer gaps */

static unsigned int attachdefault        = AttachMaster; // AttachMaster, AttachAbove, AttachAside, AttachBelow, AttachBottom

static int initshowbar             = 1;   /* 0 means no bar */

static int bar_height              = 0;   /* 0 means derive from font, >= 1 explicit height */
static int vertpad                 = 6;  /* vertical (outer) padding of bar */
static int sidepad                 = 6;  /* horizontal (outer) padding of bar */

static int iconsize                = 16;  /* icon size */
static int iconspacing             = 5;   /* space between icon and title */

static float pfact                 = 0.25; /* size of workspace previews relative to monitor size */

static int floatposgrid_x                = 5;   /* float grid columns */
static int floatposgrid_y                = 5;   /* float grid rows */

static int horizpadbar             = 6;   /* horizontal (inner) padding for statusbar (increases lrpad) */
static int vertpadbar              = 10;   /* vertical (inner) padding for statusbar (increases bh, overridden by bar_height) */

static const char slopspawnstyle[]       = "-t 0 -c 0.92,0.85,0.69,0.3 -o"; /* do NOT define -f (format) here */
static const char slopresizestyle[]      = "-t 0 -c 0.92,0.85,0.69,0.3"; /* do NOT define -f (format) here */
static unsigned int systrayspacing = 10;   /* systray spacing */
static const char *toggle_float_pos      = "50% 50% 80% 80%"; // default floating position when triggering togglefloating
static double defaultopacity       = 0;   /* client default opacity, e.g. 0.75. 0 means don't apply opacity */
static double moveopacity          = 0;   /* client opacity when being moved, 0 means don't apply opacity */
static double resizeopacity        = 0;   /* client opacity when being resized, 0 means don't apply opacity */
static double placeopacity         = 0;   /* client opacity when being placed, 0 means don't apply opacity */

/* Indicators: see lib/bar_indicators.h for options */
static int indicators[IndicatorLast] = {
	[IndicatorWsOcc] = INDICATOR_NONE,
	[IndicatorPinnedWs] = INDICATOR_NONE,
	[IndicatorFakeFullScreen] = INDICATOR_PLUS,
	[IndicatorFakeFullScreenActive] = INDICATOR_PLUS_AND_LARGER_SQUARE,
	[IndicatorFloatFakeFullScreen] = INDICATOR_PLUS,
	[IndicatorFloatFakeFullScreenActive] = INDICATOR_PLUS_AND_LARGER_SQUARE,
	[IndicatorTiled] = INDICATOR_NONE,
	[IndicatorFloating] = INDICATOR_TOP_LEFT_LARGER_SQUARE,
};

/* Custom indicators using status2d markup, e.g. enabled via INDICATOR_CUSTOM_3 */
static char *custom_2d_indicator_1 = "^c#00A523^^r0,h,w,2^"; // green underline
static char *custom_2d_indicator_2 = "^c#55cdfc^^r3,3,4,4^^c#E72608^^r4,4,2,2^"; // blue rectangle
static char *custom_2d_indicator_3 = "^f-10^^c#E72608^𐄛"; // example using a character as an indicator
static char *custom_2d_indicator_4 = "^c#E26F0B^^r0,h,w,1^^r0,0,1,h^^r0,0,w,1^^rw,0,1,h^"; // orange box
static char *custom_2d_indicator_5 = "^c#CB9700^^r0,h,w,1^^r0,0,w,1^"; // top and bottom lines
static char *custom_2d_indicator_6 = "^c#F0A523^^r6,2,1,-4^^r-6,2,1,-4^"; // orange vertical bars

/* The below are only used if the WorkspaceLabels functionality is enabled */
static char *occupied_workspace_label_format = "%s: %s";     /* format of a workspace label */
static char *vacant_workspace_label_format = "%s";           /* format of an empty / vacant workspace */
static int lowercase_workspace_labels = 1;                   /* whether to change workspace labels to lower case */
static int prefer_window_icons_over_workspace_labels = 0;    /* whether to use window icons instead of labels if present */
static int swap_occupied_workspace_label_format_strings = 0; /* 0 gives "icon: label", 1 gives "label: icon" */

/* This determines what happens with pinned workspaces on a monitor when that monitor is removed.
 *   0 - the workspaces become unpinned and are moved to another monitor or
 *   1 - the workspace clients are moved to the selected workspace on the first monitor, but
 *       the workspace itself is hidden
 *
 * Non-pinned workspaces are always redistributed among the remaining monitors.
 */
static int workspaces_per_mon = 0;

/* See util.h for options */
static uint64_t functionality = 0
//	|AutoReduceNmaster // automatically reduce the number of master clients if one is closed
//	|BanishMouseCursor // like xbanish, hides mouse cursor when using the keyboard
//	|BanishMouseCursorToCorner // makes BanishMouseCursor move the cursor to one of the corners of the focused window
//	|SmartGaps // enables no or increased gaps if there is only one visible window
	|SmartGapsMonocle // enforces no gaps in monocle layout
	|Systray // enables a systray in the bar
	|SystrayNoAlpha // disables the use of transparency for the systray, enable if you do not use a compositor
	|Swallow // allows X applications started from the command line to swallow the terminal
	|SwallowFloating // allow floating windows to swallow the terminal by default
	|CenteredWindowName // center the window titles on the bar
//	|BarActiveGroupBorderColor // use border color of active group for the bar, otherwise normal scheme is used
//	|BarMasterGroupBorderColor // use border color of master group for the bar, otherwise normal scheme is used
	|FlexWinBorders // use the SchemeFlex* color schemes, falls back to SchemeTitle* if disabled
//	|SpawnCwd // spawn applications in the currently selected client's working directory
	|ColorEmoji // enables color emoji support (removes Xft workaround)
//	|Status2DNoAlpha // option to not use alpha when drawing status2d status
//	|BarBorder // draw a border around the bar
//	|BarBorderColBg // optionally use the bar background colour for the bar border (rather than border colour)
	|BarPadding // add vertical and side padding as per vertpad and sidepad variables above
	|NoBorders // as per the noborder patch, show no border when only one client in tiled mode
	|Warp // warp cursor to currently focused window
//	|DecorationHints // omit drawing the window border if the applications asks not to
	|FocusedOnTop // allows focused window to stay on top of other windows
//	|FocusedOnTopTiled // additional toggle to allow focused tiled clients to show on top of floating windows
	|FocusFollowMouse // allow window under the mouse cursor to get focus when changing views or killing clients
//	|FocusOnClick // only allow focus change when the user clicks on windows (disables sloppy focus)
	|FocusOnNetActive // allow windows demanding attention to receive focus automatically
	|AllowNoModifierButtons // allow some window operations, like move and resize, to work without having to hold down a modifier key
	|CenterSizeHintsClients // center tiled clients subject to size hints within their tiled area
//	|ResizeHints // respect size hints also when windows are tiled
	|SnapToWindows // snap to windows when moving floating clients
//	|SnapToGaps // snap to outer gaps when moving floating clients
//	|SortScreens // monitors are numbered from left to right
	|ViewOnWs // follow a window to the workspace it is being moved to
//	|Xresources // add support for changing colours via Xresources
	|Debug // enables additional debug output
//	|AltWindowTitles // show alternate window titles, if present
//	|AltWorkspaceIcons // show the workspace name instead of the icons
//	|GreedyMonitor // disables swap of workspaces between monitors
	|SmartLayoutConversion // automatically adjust layout based on monitor orientation when moving a workspace from one monitor to another
//	|AutoHideScratchpads // automatically hide open scratchpads when moving to another workspace
//	|RioDrawIncludeBorders // indicates whether the area drawn using slop includes the window borders
//	|RioDrawSpawnAsync // spawn the application alongside rather than after drawing area using slop
//	|RestrictFocusstackToMonitor // restrict focusstack to only operate within the monitor, otherwise focus can drift between monitors
//	|WinTitleIcons // adds application icons to window titles in the bar
//	|StackerIcons // adds a stacker icon hints in window titles
//	|WorkspaceLabels // adds the class of the master client next to the workspace icon
	|WorkspacePreview // adds preview images when hovering workspace icons in the bar
;

static int flexwintitle_masterweight     = 15; // master weight compared to hidden and floating window titles
static int flexwintitle_stackweight      = 4;  // stack weight compared to hidden and floating window titles
static int flexwintitle_hiddenweight     = 0;  // hidden window title weight
static int flexwintitle_floatweight      = 0;  // floating window title weight, set to 0 to not show floating windows
static int flexwintitle_separator        = 0;  // width of client separator

static const char *fonts[] = {
	"JetBrainsMono:weight=100:pixelsize=14:antialias=true:autohint=true",
	"Font Awesome 7 Free:style=Solid:pixelsize=16"
};

static char bgdark[] = "#24283B";
static char bgmid[] = "#292E42";
static char bglight[] = "#2E3C64";
static char fglight[] = "#C0CAF5";
static char fgdark[] = "#565c7e";
static char black[] = "#000000";
static char orange[] = "#FF9E64";
static char purple[] = "#BB9AF7";
static char red[] = "#F7768E";

/* Xresources preferences to load at startup. */
static const ResourcePref resources[] = { NULL };

/* Scratch/Spawn commands:        NULL (scratchkey), command, argument, argument, ..., NULL */
static const char *termcmd[]  = { NULL };
static const char *dmenucmd[] = { NULL };

unsigned int default_alphas[] = { OPAQUE, OPAQUE, OPAQUE };

static char *colors[SchemeLast][4] = {
	/*                       fg         bg         border     resource prefix */
	[SchemeNorm]         = { fglight, bgdark, bgdark, "norm" },
	[SchemeSel]          = { fglight, bglight, bglight, "sel" },
	[SchemeTitleNorm]    = { fglight, bgdark, bgmid, "titlenorm" },
	[SchemeTitleSel]     = { fglight, bglight, bglight, "titlesel" },
	[SchemeWsNorm]       = { fgdark, bgdark, black, "wsnorm" },
	[SchemeWsVisible]    = { fglight, bglight, black, "wsvis" },
	[SchemeWsSel]        = { orange, bglight, black, "wssel" },
	[SchemeWsOcc]        = { fglight, bgdark, black, "wsocc" },
	[SchemeHidNorm]      = { fglight, bgdark, bgmid, "hidnorm" },
	[SchemeHidSel]       = { fglight, bglight, bglight, "hidsel" },
	[SchemeUrg]          = { bgdark, red, red, "urg" },
	[SchemeMarked]       = { bgdark, purple, purple, "marked" },
	[SchemeScratchNorm]  = { fglight, bgdark, bgmid, "scratchnorm" },
	[SchemeScratchSel]   = { fglight, bglight, bglight, "scratchsel" },
	[SchemeFlexActTTB]   = { fglight, bgdark, bgmid, "act.TTB" },
	[SchemeFlexActLTR]   = { fglight, bgdark, bgmid, "act.LTR" },
	[SchemeFlexActMONO]  = { fglight, bgdark, bgmid, "act.MONO" },
	[SchemeFlexActGRID]  = { fglight, bgdark, bgmid, "act.GRID" },
	[SchemeFlexActGRIDC] = { fglight, bgdark, bgmid, "act.GRIDC" },
	[SchemeFlexActGRD1]  = { fglight, bgdark, bgmid, "act.GRD1" },
	[SchemeFlexActGRD2]  = { fglight, bgdark, bgmid, "act.GRD2" },
	[SchemeFlexActGRDM]  = { fglight, bgdark, bgmid, "act.GRDM" },
	[SchemeFlexActHGRD]  = { fglight, bgdark, bgmid, "act.HGRD" },
	[SchemeFlexActDWDL]  = { fglight, bgdark, bgmid, "act.DWDL" },
	[SchemeFlexActDWDLC] = { fglight, bgdark, bgmid, "act.DWDLC" },
	[SchemeFlexActSPRL]  = { fglight, bgdark, bgmid, "act.SPRL" },
	[SchemeFlexActSPRLC] = { fglight, bgdark, bgmid, "act.SPRLC" },
	[SchemeFlexActTTMI]  = { fglight, bgdark, bgmid, "act.TTMI" },
	[SchemeFlexActTTMIC] = { fglight, bgdark, bgmid, "act.TTMIC" },
	[SchemeFlexActFloat] = { fglight, bgdark, bgmid, "act.float" },
	[SchemeFlexInaTTB]   = { fglight, bgdark, bgmid, "norm.TTB" },
	[SchemeFlexInaLTR]   = { fglight, bgdark, bgmid, "norm.LTR" },
	[SchemeFlexInaMONO]  = { fglight, bgdark, bgmid, "norm.MONO" },
	[SchemeFlexInaGRID]  = { fglight, bgdark, bgmid, "norm.GRID" },
	[SchemeFlexInaGRIDC] = { fglight, bgdark, bgmid, "norm.GRIDC" },
	[SchemeFlexInaGRD1]  = { fglight, bgdark, bgmid, "norm.GRD1" },
	[SchemeFlexInaGRD2]  = { fglight, bgdark, bgmid, "norm.GRD2" },
	[SchemeFlexInaGRDM]  = { fglight, bgdark, bgmid, "norm.GRDM" },
	[SchemeFlexInaHGRD]  = { fglight, bgdark, bgmid, "norm.HGRD" },
	[SchemeFlexInaDWDL]  = { fglight, bgdark, bgmid, "norm.DWDL" },
	[SchemeFlexInaDWDLC] = { fglight, bgdark, bgmid, "norm.DWDLC" },
	[SchemeFlexInaSPRL]  = { fglight, bgdark, bgmid, "norm.SPRL" },
	[SchemeFlexInaSPRLC] = { fglight, bgdark, bgmid, "norm.SPRLC" },
	[SchemeFlexInaTTMI]  = { fglight, bgdark, bgmid, "norm.TTMI" },
	[SchemeFlexInaTTMIC] = { fglight, bgdark, bgmid, "norm.TTMIC" },
	[SchemeFlexInaFloat] = { fglight, bgdark, bgmid, "norm.float" },
	[SchemeFlexSelTTB]   = { fglight, bglight, orange, "sel.TTB" },
	[SchemeFlexSelLTR]   = { fglight, bglight, orange, "sel.LTR" },
	[SchemeFlexSelMONO]  = { fglight, bglight, orange, "sel.MONO" },
	[SchemeFlexSelGRID]  = { fglight, bglight, orange, "sel.GRID" },
	[SchemeFlexSelGRIDC] = { fglight, bglight, orange, "sel.GRIDC" },
	[SchemeFlexSelGRD1]  = { fglight, bglight, orange, "sel.GRD1" },
	[SchemeFlexSelGRD2]  = { fglight, bglight, orange, "sel.GRD2" },
	[SchemeFlexSelGRDM]  = { fglight, bglight, orange, "sel.GRDM" },
	[SchemeFlexSelHGRD]  = { fglight, bglight, orange, "sel.HGRD" },
	[SchemeFlexSelDWDL]  = { fglight, bglight, orange, "sel.DWDL" },
	[SchemeFlexSelDWDLC] = { fglight, bglight, orange, "sel.DWDLC" },
	[SchemeFlexSelSPRL]  = { fglight, bglight, orange, "sel.SPRL" },
	[SchemeFlexSelSPRLC] = { fglight, bglight, orange, "sel.SPRLC" },
	[SchemeFlexSelTTMI]  = { fglight, bglight, orange, "sel.TTMI" },
	[SchemeFlexSelTTMIC] = { fglight, bglight, orange, "sel.TTMIC" },
	[SchemeFlexSelFloat] = { fglight, bglight, orange, "sel.float" },
};

/* List of programs to start automatically during startup only. Note that these will not be
 * executed again when doing a restart. */
static const char *const autostart[] = {
	"dusk-statusbar",
	NULL /* terminate */
};

/* List of programs to start automatically during a restart only. These should usually be short
 * scripts that perform specific operations, e.g. changing a wallpaper. */
static const char *const autorestart[] = {
	"dusk-statusbar",
	NULL /* terminate */
};

/* There are two options when it comes to per-client rules:
 *  - a traditional struct table or
 *  - specifying the fields used
 *
 * A traditional struct table looks like this:
 *    // class      role      instance  title  wintype  opacity   flags   floatpos   scratchkey   workspace
 *    { "Gimp",     NULL,     NULL,     NULL,  NULL,    0,        0,      NULL,      NULL,        "4"        },
 *    { "Firefox",  NULL,     NULL,     NULL,  NULL,    0,        0,      NULL,      NULL,        "9"        },
 *
 * Alternatively you can specify the fields that are relevant to your rule, e.g.
 *
 *    { .class = "Gimp", .workspace = "5" },
 *    { .class = "Firefox", .workspace = "9" },
 *
 * Any fields that you do not specify will default to 0 or NULL.
 *
 * Refer to the Rule struct definition for the list of available fields.
 */
static Rule clientrules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	WM_WINDOW_ROLE(STRING) = role
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
	{ .class = "DesktopEditors", .flags = 0 },
	{ .class = "ONLYOFFICE", .flags = 0 },
	{ .wintype = "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE", .flags = Unmanaged },
	{ .wintype = WTYPE "DESKTOP", .flags = Unmanaged|Lower },
	{ .wintype = WTYPE "DOCK", .flags = Unmanaged|Raise },
	{ .wintype = WTYPE "DIALOG", .flags = AlwaysOnTop|Centered|Floating },
	{ .wintype = WTYPE "UTILITY", .flags = AlwaysOnTop|Centered|Floating },
	{ .wintype = WTYPE "TOOLBAR", .flags = AlwaysOnTop|Centered|Floating },
	{ .wintype = WTYPE "SPLASH", .flags = AlwaysOnTop|Centered|Floating },
	{ .role = "pop-up", .flags = AlwaysOnTop|Floating|Centered },
	// Terminals
	{ .class = "org.wezfurlong.wezterm", .flags = Terminal|NoSwallow },
	{ .class = "st-256color", .flags = Terminal|NoSwallow },
	// General
	{ .instance = "Navigator", .class = "zen-default", .flags = NoSwallow|SwitchWorkspace, .workspace = "1" },
	{ .instance = "Navigator", .class = "zen-personal", .flags = NoSwallow|SwitchWorkspace, .workspace = "4" },
	{ .instance = "steamwebhelper", .class = "steam", .flags = Floating|Centered|SwitchWorkspace, .workspace = "6" },
	{ .class = "steam_app_", .flags = SteamGame|SwitchWorkspace, .workspace = "6" },
	{ .instance = "vesktop", .class = "vesktop", .flags = SwitchWorkspace, .workspace = "6" },
	{ .title = "Event Tester", .flags = NoSwallow },
};

/* Bar settings, this defines what bars exists, their position, and what attributes they have.
 *
 *    monitor   - the exact monitor number the bar should be created on
 *                (0 - primary, 1 - secondary, 2 - tertiary)
 *    idx       - the bar index, used in relation to bar rules below
 *                (bar indexes can be reused across monitors)
 *    vert      - whether the bar is horizontal (0) or vertical (1), not
 *                all bar modules will have support for being displayed
 *                in a vertical bar
 *    name      - this is just a reference that can be used for logging
 *                purposes
 *    ext class - WM class to match on for external bars
 *    ext inst  - WM instance to match on for external bars
 *    ext name  - WM name to match on for external bars
 *
 *    Bar positioning consists of four values, x, y, w and h which,
 *    similarly to floatpos, can have different meaning depending on
 *    the characters used. Absolute positioning (as in cross-monitor)
 *    is not supported, but exact positions relative to the monitor
 *    can be used. Percentage values are recommended for portability.
 *
 *    All values can be a percentage relative to the space available
 *    on the monitor or they can be exact values, here are some example
 *    values:
 *       x
 *                  0% - left aligned (default)
 *                100% - right aligned
 *                 50% - bar is centered on the screen
 *                  0x - exact position relative to the monitor
 *                 -1x - value < 0 means use default
 *       y
 *                  0% - top bar (default)
 *                100% - bottom bar
 *                  0y - exact position relative to the monitor
 *                 -1y - value < 0 means use default
 *       w
 *                100% - bar takes up the full width of the screen (default)
 *                 20% - small bar taking a fifth of the width of the screen
 *                500w - the bar is 500 pixels wide (including border)
 *                 -1w - value <= 0 means use default
 *       h
 *                100% - bar takes up the full height of the screen
 *                 20% - small bar taking a fifth of the height of screen
 *                 30h - the bar is 30 pixels high (including border)
 *                 -1h - value <= 0 means use the default (deduced by font size)
 *
 *    Note that vertical and horizontal side padding are controlled by the
 *    vertpad and sidepad variables towards the top of this configuration file.
 */
static BarDef bars[] = {
	/* monitor idx  vert   x     y      w     h     name            ext class  ext inst  ext name */
	{  0,      0,   0,    "0%    0%     100% -1h ", "Primary top" },
	{  0,      1,   0,    "0%    100%   100% -1h ", "Primary bottom" },
	{  1,      0,   0,    "0%    0%     100% -1h ", "Secondary top" },
	{  1,      1,   0,    "0%    100%   100% -1h ", "Secondary bottom" },
	{  2,      0,   0,    "0%    0%     100% -1h ", "Tertiary top" },
	{  2,      1,   0,    "0%    100%   100% -1h ", "Tertiary bottom" },
};

/* Bar rules allow you to configure what is shown where on the bar, as well as
 * introducing your own bar modules.
 *
 *    monitor:
 *      -1  show on all monitors
 *       0  show on monitor 0
 *      'A' show on active monitor (i.e. follow focused monitor)
 *    bar - bar index, 0 is default, 1 is extrabar
 *    scheme - defines the default scheme for the bar module
 *    lpad - adds artificial spacing on the left hand side of the module
 *    rpad - adds artificial spacing on the right hand side of the module
 *    value - arbitrary value where the interpretation is module specific
 *    alignment - how the module is aligned compared to other modules
 *    sizefunc, drawfunc, clickfunc - providing bar module width, draw and click functions
 *    name - does nothing, intended for visual clue and for logging / debugging
 */
#define PWRL PwrlNone
static BarRule barrules[] = {
/* monitor bar scheme lpad rpad  value     alignment              sizefunc                drawfunc                clickfunc                hoverfunc         name */
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_LEFT,        size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_LEFT,        size_workspaces,        draw_workspaces,        click_workspaces,        hover_workspaces, "workspaces" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   13,   0,        BAR_ALIGN_RIGHT,       size_systray,           draw_systray,           click_systray,           NULL,             "systray" },
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_LEFT,        size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{ -1,      0,  7,      0,   0,   0,        BAR_ALIGN_LEFT,        size_ltsymbol,          draw_ltsymbol,          click_ltsymbol,          NULL,             "layout" },
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_LEFT,        size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      8,   8,   0,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-calendar" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      8,   8,   1,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-clock" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      8,   8,   2,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-memory" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   8,   3,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-volume" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   8,   4,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-updates" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   8,   5,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-spotify" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   0,   6,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status-test" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   0,   7,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status7" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   0,   8,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status8" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{  0,      0,  0,      0,   0,   9,        BAR_ALIGN_RIGHT,       size_status,            draw_status,            click_status,            NULL,             "status9" },
{  0,      0,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT,       size_powerline,         draw_powerline,         NULL,                    NULL,             "powerline join" },
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_NONE,        size_wintitle_sticky,   draw_wintitle_sticky,   click_wintitle_sticky,   NULL,             "wintitle_sticky" },
{ -1,      0,  0,      0,   0,   PWRL, BAR_ALIGN_NONE,        size_flexwintitle,      draw_flexwintitle,      click_flexwintitle,      NULL,             "flexwintitle" },
{ -1,      1,  0,      0,   0,   PWRL, BAR_ALIGN_CENTER,      size_pwrl_ifhidfloat,   draw_powerline,         NULL,                    NULL,             "powerline join" },
{ -1,      1,  0,      0,   0,   PWRL, BAR_ALIGN_RIGHT_RIGHT, size_wintitle_hidden,   draw_wintitle_hidden,   click_wintitle_hidden,   NULL,             "wintitle_hidden" },
{ -1,      1,  0,      0,   0,   PWRL, BAR_ALIGN_LEFT_LEFT,   size_wintitle_floating, draw_wintitle_floating, click_wintitle_floating, NULL,             "wintitle_floating" },
};

/* Workspace rules define what workspaces are available and their properties.
 *
 *    name     - the name of the workspace, this is a reference used for keybindings - see WSKEYS
 *    monitor  - the monitor number the workspace starts on by default, -1 means assign freely
 *    pinned   - whether the workspace is pinned on the assigned monitor
 *    layout   - the layout index the workspace should start with, refer to the layouts array
 *    mfact    - factor of master area size, -1 means use global config
 *    nmaster  - number of clients in master area, -1 means use global config
 *    nstack   - number of clients in primary stack area, -1 means use global config
 *    gaps     - whether gaps are enabled for the workspace, -1 means use global config
 *
 *    icons:
 *       def   - the default icon shown for the workspace, if empty string then the workspace is
 *               hidden by default, if NULL then the workspace name is used for the icon
 *       vac   - the vacant icon shows if the workspace is selected, the default icon is an empty
 *               string (hidden by default) and the workspace has no clients
 *       occ   - the occupied icon shows if the workspace has clients
 *
 */
static WorkspaceRule wsrules[] = {
	/*                                                                     ------------------------------- schemes ------------------------------- ------ icons ------
	   name,  monitor,  pinned,  layout,  mfact,  nmaster,  nstack,  gaps, default,          visible,          selected,         occupied,         def,   vac,  occ,  */
	{  "1",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
	{  "2",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
	{  "3",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
	{  "4",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
	{  "5",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
	{  "6",   -1,       0,       0,       -1,    -1,       -1,      -1,    SchemeWsNorm,     SchemeWsVisible,  SchemeWsSel,      SchemeWsOcc,      "",   "",   "", },
};

static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int nstack      = 0;    /* number of clients in primary stack area */
static int enablegaps  = 1;    /* whether gaps are enabled by default or not */

/* layout(s) */
static Layout layouts[] = {
	/* symbol     arrange function, { nmaster, nstack, layout, master axis, stack axis, secondary stack axis, symbol func }, name */
	{ " []= ",      flextile,         { -1, -1, SPLIT_VERTICAL, TOP_TO_BOTTOM, TOP_TO_BOTTOM, 0, NULL }, "tile" },
	{ " [M] ",      flextile,         { -1, -1, NO_SPLIT, MONOCLE, MONOCLE, 0, NULL }, "monocle" },
	{ " (@) ",      flextile,         { -1, -1, NO_SPLIT, SPIRAL_CFACTS, SPIRAL_CFACTS, 0, NULL }, "fibonacci spiral" },
	{ " [\\] ",     flextile,         { -1, -1, NO_SPLIT, DWINDLE_CFACTS, DWINDLE_CFACTS, 0, NULL }, "fibonacci dwindle" },
	{ " [T] ",      flextile,         { -1, -1, SPLIT_VERTICAL, LEFT_TO_RIGHT, TATAMI_CFACTS, 0, NULL }, "tatami mats" },
	{ " ||| ",      flextile,         { -1, -1, NO_SPLIT, LEFT_TO_RIGHT, LEFT_TO_RIGHT, 0, NULL }, "columns" },
	{ " === ",      flextile,         { -1, -1, NO_SPLIT, TOP_TO_BOTTOM, TOP_TO_BOTTOM, 0, NULL }, "rows" },
	{ " ||= ",      flextile,         { -1, -1, SPLIT_VERTICAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, 0, NULL }, "col" },
	{ " ::: ",      flextile,         { -1, -1, NO_SPLIT, GAPLESSGRID_CFACTS, GAPLESSGRID_CFACTS, 0, NULL }, "gapless grid" },
	{ " TTT ",      flextile,         { -1, -1, SPLIT_HORIZONTAL, LEFT_TO_RIGHT, LEFT_TO_RIGHT, 0, NULL }, "bstack" },
	{ " === ",      flextile,         { -1, -1, SPLIT_HORIZONTAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, 0, NULL }, "bstackhoriz" },
	{ " ==# ",      flextile,         { -1, -1, SPLIT_HORIZONTAL, TOP_TO_BOTTOM, GAPLESSGRID_CFACTS, 0, NULL }, "bstackgrid" },
	{ " >M> ",      flextile,         { -1, -1, FLOATING_MASTER, LEFT_TO_RIGHT, LEFT_TO_RIGHT, 0, NULL }, "floating master" },
	{ " |M| ",      flextile,         { -1, -1, SPLIT_CENTERED_VERTICAL, LEFT_TO_RIGHT, TOP_TO_BOTTOM, TOP_TO_BOTTOM, NULL }, "centeredmaster" },
	{ " -M- ",      flextile,         { -1, -1, SPLIT_CENTERED_HORIZONTAL, TOP_TO_BOTTOM, LEFT_TO_RIGHT, LEFT_TO_RIGHT, NULL }, "centeredmaster horiz" },
 	{ " ><> ",      NULL,             { -1, -1 }, "floating" }, /* no layout function means floating behavior */
	{ " [D] ",      flextile,         { -1, -1, SPLIT_VERTICAL, TOP_TO_BOTTOM, MONOCLE, 0, NULL }, "deck" },
};

#define Shift ShiftMask
#define Ctrl ControlMask
#define Alt Mod1Mask
#define AltGr Mod3Mask
#define Super Mod4Mask
#define ShiftGr Mod5Mask

/* key definitions */
#define MODKEY Super

#define SCRATCHKEYS(MOD,KEY,CMD) \
	{ KeyPress,   MOD,                      KEY,      togglescratch,       {.v = CMD } }, \
	{ KeyPress,   MOD|Ctrl,                 KEY,      setscratch,          {.v = CMD } }, \
	{ KeyPress,   MOD|Ctrl|Shift,           KEY,      removescratch,       {.v = CMD } }, \

#define WSKEYS(MOD,KEY,NAME) \
	{ KeyPress,   MOD,                      KEY,      comboviewwsbyname,   {.v = NAME} }, \
	{ KeyPress,   MOD|Alt,                  KEY,      enablewsbyname,      {.v = NAME} }, \
	{ KeyPress,   MOD|Shift,                KEY,      movetowsbyname,      {.v = NAME} }, \
	{ KeyPress,   MOD|Ctrl,                 KEY,      sendtowsbyname,      {.v = NAME} }, \
	{ KeyPress,   MOD|Ctrl|Shift,           KEY,      movealltowsbyname,   {.v = NAME} }, \
	{ KeyPress,   MOD|Ctrl|Alt,             KEY,      moveallfromwsbyname, {.v = NAME} }, \
	{ KeyPress,   MOD|Ctrl|Alt|Shift,       KEY,      swapwsbyname,        {.v = NAME} }, \

#define STACKKEYS(MOD,ACTION) \
	{ KeyPress,   MOD, XK_j, ACTION, {.i = INC(+1) } }, \
	{ KeyPress,   MOD, XK_k, ACTION, {.i = INC(-1) } }, \
	{ KeyPress,   MOD, XK_s, ACTION, {.i = PREVSEL } }, \
	{ KeyPress,   MOD, XK_w, ACTION, {.i = 1 } }, \
	{ KeyPress,   MOD, XK_e, ACTION, {.i = 2 } }, \
	{ KeyPress,   MOD, XK_a, ACTION, {.i = 3 } }, \
	{ KeyPress,   MOD, XK_z, ACTION, {.i = LASTTILED } },

/* This relates to the StackerIcons functionality and should mirror the STACKKEYS list above. */
static StackerIcon stackericons[] = {
	{ "[j]", {.i = INC(+1) } },
	{ "[k]", {.i = INC(-1) } },
	{ "[s]", {.i = PREVSEL } },
	{ "[w]", {.i = 1 } },
	{ "[e]", {.i = 2 } },
	{ "[a]", {.i = 3 } },
	{ "[z]", {.i = LASTTILED } },
};

/* Helper macros for spawning commands */
#define SHCMD(cmd) { .v = (const char*[]){ NULL, "/bin/sh", "-c", cmd, NULL } }
#define CMD(...)   { .v = (const char*[]){ NULL, __VA_ARGS__, NULL } }

static const char *statusclickcmd[] = { "dusk-statusclick", NULL };

static Key keys[] = {
	WSKEYS(MODKEY,                              XK_1,            "1")
	WSKEYS(MODKEY,                              XK_2,            "2")
	WSKEYS(MODKEY,                              XK_3,            "3")
	WSKEYS(MODKEY,                              XK_4,            "4")
	WSKEYS(MODKEY,                              XK_5,            "5")
	WSKEYS(MODKEY,                              XK_6,            "6")
	WSKEYS(MODKEY,                              XK_7,            "7")
	WSKEYS(MODKEY,                              XK_8,            "8")
	WSKEYS(MODKEY,                              XK_9,            "9")
};

/* button definitions */
/* click can be ClkWorkspaceBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                     event mask               button          function          argument */
	{ ClkLtSymbol,               0,                       Button1,        setlayout,        {-1} }, // toggles between current and previous layout
	{ ClkLtSymbol,               0,                       Button4,        cyclelayout,      {.i = +1 } }, // cycle through the available layouts
	{ ClkLtSymbol,               0,                       Button5,        cyclelayout,      {.i = -1 } }, // cycle through the available layouts (in reverse)
	{ ClkWinTitle,               0,                       Button1,        focuswin,         {0} }, // focus on the given client
	{ ClkWinTitle,               0,                       Button3,        showhideclient,   {0} }, // hide the currently selected client (or show if hidden)
	{ ClkWinTitle,               0,                       Button2,        zoom,             {0} }, // moves the currently focused window to/from the master area (for tiled layouts)
	{ ClkStatusText,             0,                       Button1,        statusclick,      {.i = 1 } }, // sends mouse button presses to statusclick script when clicking on status modules
	{ ClkStatusText,             0,                       Button2,        statusclick,      {.i = 2 } },
	{ ClkStatusText,             0,                       Button3,        statusclick,      {.i = 3 } },
	{ ClkStatusText,             0,                       Button4,        statusclick,      {.i = 4 } },
	{ ClkStatusText,             0,                       Button5,        statusclick,      {.i = 5 } },
	{ ClkStatusText,             0,                       Button6,        statusclick,      {.i = 6 } },
	{ ClkStatusText,             0,                       Button7,        statusclick,      {.i = 7 } },
	{ ClkStatusText,             0,                       Button8,        statusclick,      {.i = 8 } },
	{ ClkStatusText,             0,                       Button9,        statusclick,      {.i = 9 } },
	{ ClkStatusText,             Shift,                   Button1,        statusclick,      {.i = 10 } },
	{ ClkStatusText,             Shift,                   Button2,        statusclick,      {.i = 11 } },
	{ ClkStatusText,             Shift,                   Button3,        statusclick,      {.i = 12 } },
	{ ClkStatusText,             MODKEY,                  Button1,        statusclick,      {.i = 13 } },
	{ ClkStatusText,             MODKEY,                  Button2,        statusclick,      {.i = 14 } },
	{ ClkStatusText,             MODKEY,                  Button3,        statusclick,      {.i = 15 } },
	{ ClkClientWin,              MODKEY,                  Button8,        markmouse,        {1} }, // toggles marking of clients under the mouse cursor for group action
	{ ClkClientWin,              MODKEY,                  Button9,        markmouse,        {0} }, // unmarks clients under the mouse cursor
	{ ClkClientWin,              MODKEY,                  Button1,        moveorplace,      {1} }, // moves a client window into a floating or tiled position depending on floating state
	{ ClkClientWin,              MODKEY|Shift,            Button1,        movemouse,        {0} }, // moves a floating window, if the window is tiled then it will snap out to become floating
	{ ClkClientWin,              MODKEY|Alt,              Button2,        togglefloating,   {0} }, // toggles between tiled and floating arrangement for given client
	{ ClkClientWin,              MODKEY,                  Button3,        resizeorfacts,    {0} }, // change the size of a floating client window or adjust cfacts and mfacts when tiled
	{ ClkClientWin,              MODKEY|Shift,            Button3,        resizemouse,      {0} }, // change the size of a floating client window
	{ ClkClientWin,              0,                       Button8,        movemouse,        {0} }, // move a client window using extra mouse buttons (previous)
	{ ClkClientWin,              0,                       Button9,        resizemouse,      {0} }, // resize a client window using extra mouse buttons (next)
	{ ClkClientWin,              MODKEY,                  Button2,        zoom,             {0} }, // moves the currently focused window to/from the master area (for tiled layouts)
	{ ClkClientWin,              MODKEY|Ctrl,             Button1,        dragmfact,        {0} }, // dynamically change the size of the master area compared to the stack area(s)
	{ ClkRootWin,                MODKEY|Ctrl,             Button1,        dragmfact,        {0} }, // dynamically change the size of the master area compared to the stack area(s)
	{ ClkClientWin,              MODKEY|Ctrl,             Button3,        dragwfact,        {0} }, // dynamically change the size of a workspace relative to other workspaces
	{ ClkRootWin,                MODKEY|Ctrl,             Button3,        dragwfact,        {0} }, // dynamically change the size of a workspace relative to other workspaces
	{ ClkClientWin,              MODKEY,                  Button4,        inplacerotate,    {.i = +1 } }, // rotate clients within the respective area (master, primary stack, secondary stack) clockwise
	{ ClkClientWin,              MODKEY,                  Button5,        inplacerotate,    {.i = -1 } }, // rotate clients within the respective area (master, primary stack, secondary stack) counter-clockwise
	{ ClkClientWin,              MODKEY|Shift,            Button4,        rotatestack,      {.i = +1 } }, // rotate all clients (clockwise)
	{ ClkClientWin,              MODKEY|Shift,            Button5,        rotatestack,      {.i = -1 } }, // rotate all clients (counter-clockwise)
	{ ClkWorkspaceBar,           0,                       Button1,        viewws,           {0} }, // view the workspace by clicking on workspace icon
	{ ClkWorkspaceBar,           MODKEY,                  Button1,        movews,           {0} }, // sends (moves) the currently focused client to given workspace
	{ ClkWorkspaceBar,           MODKEY|Shift|Ctrl,       Button1,        swapws,           {0} }, // swaps all clients on current workspace with that of the given workspace
	{ ClkWorkspaceBar,           0,                       Button3,        enablews,         {0} }, // enables the workspace in addition to other workspaces
	{ ClkWorkspaceBar,           0,                       Button4,        viewwsdir,        {.i = +2 } }, // view the next workspace right of current workspace that has clients (on the current monitor)
	{ ClkWorkspaceBar,           0,                       Button5,        viewwsdir,        {.i = -2 } }, // view the next workspace left of current workspace that has clients (on the current monitor)
	{ ClkWorkspaceBar,           MODKEY,                  Button2,        togglepinnedws,   {0} }, // toggles the pinning of a workspace to the current monitor
};
