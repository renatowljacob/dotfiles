/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 6;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 6;       /* vert inner gap between windows */
static const unsigned int gappoh    = 6;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 6;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int vertpadbar	    = 6;	/* horizontal padding for statusbar */
static const int horizpadbar	    = 6;	/* vertical padding for statusbar */
static const int vertpad	    = 6;	/* vertical padding of bar */
static const int sidepad	    = 6;	/* horizontal padding of bar */
static const char *fonts[]          = {
	"JetBrainsMono NF:style=Medium:pixelsize=14:antialias=true:autohint=true",
};
static const char dmenufont[]       = { 
	"JetBrainsMono NF:style=Medium:pixelsize=14:antialias=true:autohint=true" 
};	
static const char bar_accent[]       = "#283457"; // bar accent color
static const char bar_bg[]           = "#1a1b26"; // bar background color
static const char fg_accent[]        = "#c0caf5"; // bar_accent foreground color
static const char fg_bg[]	     = "#a9b1d6"; // bar_bg foreground color
static const char border_focused[]   = "#ff9e64"; // focused border color
static const char border_unfocused[] = "#292e42"; // unfocused border color
static const char *colors[][3]       = {
	/*               fg         bg           border   */
	[SchemeNorm] = { fg_bg,     bar_bg,      border_unfocused },
	[SchemeSel]  = { fg_accent, bar_accent,  border_focused  },
};

/* tagging */
static const char *tags[] = { "", "", "", "", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      	     instance    title    tags mask     isfloating   monitor */
	{ "Gimp",            NULL,       NULL,    0,            1,           -1 },
	{ "Vivaldi-stable",  NULL,	 NULL,	  1,	        0,	     -1 },
	{ "vesktop",         NULL,	 NULL,	  1 << 1,	0,	     -1 },
	{ "steam",	     NULL,	 NULL,	  1 << 2,	0,	     -1 },
	{ "Spotify",	     NULL,	 NULL,	  1 << 3,	0,	     -1 },
	{ "qBittorrent",     NULL,	 NULL,	  1 << 8,	0,	     -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "Fl",       NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ KeyPress,   MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ KeyPress,   MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ KeyPress,   MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ KeyPress,   MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", bar_bg, "-nf", fg_accent, "-sb", bar_accent, "-sf", fg_bg, NULL };
static const char *termcmd[]  = { "kitty", NULL };

#include "movestack.c"
static const Key keys[] = {
	/* type         modifier                      key                   function        argument */
	{ KeyPress,	0,			      XK_ISO_Level3_Shift,  spawn,          {.v = dmenucmd } },
	{ KeyPress,	MODKEY,	                      XK_Return,            spawn,          {.v = termcmd } },
	{ KeyPress,	MODKEY,                       XK_b,                 togglebar,      {0} },
	{ KeyPress,	MODKEY,                       XK_j,                 focusstack,     {.i = +1 } },
	{ KeyPress,	MODKEY,                       XK_k,                 focusstack,     {.i = -1 } },
	{ KeyPress,	MODKEY,                       XK_i,                 incnmaster,     {.i = +1 } },
	{ KeyPress,	MODKEY,                       XK_d,                 incnmaster,     {.i = -1 } },
	{ KeyPress,	MODKEY,                       XK_h,                 setmfact,       {.f = -0.05} },
	{ KeyPress,	MODKEY,                       XK_l,                 setmfact,       {.f = +0.05} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_h,                 setcfact,       {.f = +0.25} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_l,                 setcfact,       {.f = -0.25} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_i,                 incrgaps,       {.i = +1 } },
	{ KeyPress,	MODKEY|ShiftMask,             XK_u,                 incrgaps,       {.i = -1 } },
	{ KeyPress,	MODKEY|ControlMask,           XK_0,                 togglegaps,     {0} },
	{ KeyPress,	MODKEY|ControlMask|ShiftMask, XK_0,                 defaultgaps,    {0} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_j,                 movestack,      {.i = +1 } },
	{ KeyPress,	MODKEY|ShiftMask,             XK_k,                 movestack,      {.i = -1 } },
	{ KeyPress,	MODKEY|ControlMask,           XK_Return,            zoom,           {0} },
	{ KeyPress,	MODKEY,                       XK_Tab,               view,           {0} },
	{ KeyPress,	MODKEY,	                      XK_c,                 killclient,     {0} },
	{ KeyPress,	MODKEY,                       XK_t,                 setlayout,      {.v = &layouts[0]} },
	{ KeyPress,	MODKEY,                       XK_f,                 setlayout,      {.v = &layouts[1]} },
	{ KeyPress,	MODKEY,                       XK_m,                 setlayout,      {.v = &layouts[2]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_s,                 setlayout,      {.v = &layouts[3]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_w,                 setlayout,      {.v = &layouts[4]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_d,                 setlayout,      {.v = &layouts[5]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_b,                 setlayout,      {.v = &layouts[6]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_v,                 setlayout,      {.v = &layouts[7]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_a,                 setlayout,      {.v = &layouts[8]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_z,                 setlayout,      {.v = &layouts[9]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_x,                 setlayout,      {.v = &layouts[10]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_e,                 setlayout,      {.v = &layouts[11]} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_r,                 setlayout,      {.v = &layouts[12]} },
	{ KeyPress,	MODKEY,                       XK_space,             setlayout,      {0} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_space,             togglefloating, {0} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_f,                 togglefullscr,  {0} },
	{ KeyPress,	MODKEY,                       XK_0,                 view,           {.ui = ~0 } },
	{ KeyPress,	MODKEY|ShiftMask,             XK_0,                 tag,            {.ui = ~0 } },
	{ KeyPress,	MODKEY,                       XK_comma,             focusmon,       {.i = -1 } },
	{ KeyPress,	MODKEY,                       XK_period,            focusmon,       {.i = +1 } },
	{ KeyPress,	MODKEY|ShiftMask,             XK_comma,             tagmon,         {.i = -1 } },
	{ KeyPress,	MODKEY|ShiftMask,             XK_period,            tagmon,         {.i = +1 } },
	{ KeyPress,	MODKEY,                       XK_n,                 viewnext,       {0} },
	{ KeyPress,	MODKEY,                       XK_p,                 viewprev,       {0} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_n,                 tagtonext,      {0} },
	{ KeyPress,	MODKEY|ShiftMask,             XK_p,                 tagtoprev,      {0} },
	{ KeyPress,     MODKEY|ShiftMask,             XK_q,                 quit,           {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
