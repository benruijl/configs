/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*";

static const char normbordercolor[] = "#292929";
static const char normbgcolor[]     = "#0f0f11";
static const char normfgcolor[]     = "#656565";
static const char selbordercolor[]  = "#707070";
static const char selbgcolor[]      = "#0f0f11";
static const char selfgcolor[]      = "#bababa";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "web", "term", "code", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            True,        -1 },
    { "MPlayer",  NULL,       NULL,       0,            True,        -1 },
    { "Vlc",      NULL,       NULL,       0,            True,        -1 },
    { "Eclipse",  NULL,       NULL,       1 << 2,       False,       -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[T]",      tile },    /* first entry is default */
    { "[H]",      bstack },    /* first entry is default */
    { "[F]",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define ALSADEV "Master"
#define ALSARATE "2%"

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "urxvtc", NULL };
static const char *webcmd[]  = { "google-chrome", NULL };
static const char *fmcmd[]  = { "urxvtc", "-e", "ranger", NULL };
static const char *audiocmd[]  = { "urxvtc", "-e", "ncmpcpp", NULL };
static const char *audiotoggle[]  = { "ncmpcpp", "toggle", NULL };
static const char *audioprev[]  = { "ncmpcpp", "prev", NULL };
static const char *audionext[]  = { "ncmpcpp", "next", NULL };
static const char *audiostop[]  = { "ncmpcpp", "stop", NULL };
static const char *volup[]  = { "amixer", "-q", "set", ALSADEV, ALSARATE"+", "unmute", NULL };
static const char *voldown[]  = { "amixer", "-q", "set", ALSADEV, ALSARATE"-", "unmute", NULL };
static const char *haltcmd[]  = { "sudo", "shutdown", "-h", "now", NULL };
static const char *resetcmd[]  = { "sudo", "shutdown", "-r", "now", NULL };
static const char *kbuscmd[]  = { "setxkbmap", "-layout", "us", NULL };
static const char *kbusintlcmd[]  = { "setxkbmap", "-layout", "us_intl", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY|ControlMask,           XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_y,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[3]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0),
    TAGKEYS(                        XK_2,                      1),
    TAGKEYS(                        XK_3,                      2),
    TAGKEYS(                        XK_4,                      3),
    TAGKEYS(                        XK_5,                      4),
    TAGKEYS(                        XK_6,                      5),
    TAGKEYS(                        XK_7,                      6),
    TAGKEYS(                        XK_8,                      7),
    TAGKEYS(                        XK_9,                      8),
    { MODKEY,                       XK_Left,   viewcycle,      {.i = -1 } },
    { MODKEY,                       XK_Right,  viewcycle,      {.i = +1 } },
    { MODKEY|ShiftMask,             XK_Left,   tagcycle,       {.i = -1 } },
    { MODKEY|ShiftMask,             XK_Right,  tagcycle,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },

    /* custom */
    { MODKEY,                       XK_b,      spawn,          {.v = webcmd } },
    { MODKEY,                       XK_g,      spawn,          {.v = fmcmd } },
    { MODKEY|ControlMask,           XK_m,      spawn,          {.v = audiocmd } },
    { MODKEY|ControlMask,           XK_Left,   spawn,          {.v =  audioprev} },
    { MODKEY|ControlMask,           XK_Right,  spawn,          {.v =  audionext} },
    { MODKEY|ControlMask,           XK_Up,     spawn,          {.v =  volup} },
    { MODKEY|ControlMask,           XK_Down,   spawn,          {.v =  voldown} },
    { MODKEY|ControlMask,           XK_Home,   spawn,          {.v =  audiotoggle} },
    { MODKEY|ControlMask,           XK_End,    spawn,          {.v =  audiostop} },

    { MODKEY|ControlMask|ShiftMask, XK_Prior,  spawn,          {.v = resetcmd} },
    { MODKEY|ControlMask|ShiftMask, XK_Next,   spawn,          {.v = haltcmd} },
    { MODKEY|ControlMask|ShiftMask, XK_minus,  spawn,          {.v = kbuscmd} },
    { MODKEY|ControlMask|ShiftMask, XK_equal,  spawn,          {.v = kbusintlcmd} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
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

