--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- IMPORTS {{{

import XMonad hiding ( (|||) )
import Data.Monoid
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio
import System.IO
import System.Exit

-- <actions>
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS (nextWS,prevWS,toggleWS,shiftToNext,shiftToPrev)
--import XMonad.Actions.FocusNth
import XMonad.Actions.RotSlaves (rotAllUp,rotAllDown,rotSlavesDown,rotSlavesUp)
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowGo
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.FloatKeys (keysMoveWindow,keysResizeWindow)
import XMonad.Actions.WithAll
import XMonad.Actions.Search
import XMonad.Actions.Submap
import qualified XMonad.Actions.Search as S
import qualified XMonad.Actions.Submap as SM

-- <hooks>
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts,avoidStrutsOn,ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops (ewmhDesktopsStartup)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook

-- <utilities>
import XMonad.Util.Cursor
import XMonad.Util.Run
import XMonad.Util.Scratchpad (scratchpadManageHook,scratchpadSpawnActionCustom)
--import XMonad.Util.SpawnOnce

-- <prompts>
import XMonad.Prompt
import qualified XMonad.Prompt as P
import XMonad.Prompt.XMonad
import XMonad.Prompt.Shell
import XMonad.Prompt.AppLauncher
import XMonad.Prompt.AppLauncher as AL
import XMonad.Prompt.AppendFile (appendFilePrompt)
import XMonad.Prompt.Man (manPrompt)
import XMonad.Prompt.Window (windowPromptBring,windowPromptGoto)

-- <layouts>
import XMonad.Layout.OneBig
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
--import XMonad.Layout.HintedTile

-- <layout helpers>
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LimitWindows
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Named
import XMonad.Layout.WindowNavigation
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize

-- Custom settings
myTerminal      = "urxvtc"
myBitmapsDir    = "/home/ben/.xmonad/icons"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask

-- Define clickable workspaces
myWorkspaces    = (map dzenEscape) $ ["web","term","code","video","misc","music","irc", "8","9"]
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                            (i,ws) <- zip [1..] l,
                            let n = i ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#dddddd"


---------------
-----------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- Quit xmonad
      ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- launch a terminal
    , ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    
    -- Let window float
    , ((modm,               xK_f     ), withFocused $ float)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    , ((modm,                xK_Left ), prevWS) 
    , ((modm,                xK_Right ), nextWS) 
    , ((modm .|. shiftMask,  xK_Left ), shiftToNext >> prevWS) 
    , ((modm .|. shiftMask,  xK_Right ), shiftToPrev >> nextWS) 

    -- Urgents
     , ((modm              , xK_BackSpace), focusUrgent)
     , ((modm .|. shiftMask, xK_BackSpace), clearUrgents)

    -- Custom commands
    , ((modm,                xK_b     ), unsafeSpawn "google-chrome" )
    , ((modm .|. controlMask,xK_m     ), runInTerm "" "ncmpcpp" )
    , ((modm,xK_g     ), runInTerm "" "ranger" )
    , ((modm .|. controlMask,xK_Left  ), unsafeSpawn "ncmpcpp prev" )
    , ((modm .|. controlMask,xK_Right ), unsafeSpawn "ncmpcpp next" )
    , ((modm .|. controlMask,xK_Home  ), unsafeSpawn "ncmpcpp toggle" )
    , ((modm .|. controlMask,xK_End   ), unsafeSpawn "ncmpcpp stop" )
    , ((modm .|. controlMask,xK_Up    ), unsafeSpawn "amixer set Master 2%+" )
    , ((modm .|. controlMask,xK_Down  ), unsafeSpawn "amixer set Master 2%-" )
    , ((controlMask .|. mod1Mask ,xK_l), unsafeSpawn "sflock -b 21" )
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    -- mod-control-[1..9], Copy client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, controlMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full ||| simplestFloat  
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook =  manageDocks <+>  composeAll 
    [ isFullscreen                  --> doFullFloat 
    , isDialog                      --> doCenterFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "Vlc"            --> doFloat
    , className =? "Eclipse"        --> doShift "code"
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

myLogHook h = dynamicLogWithPP $ dzenPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#161616" . pad
      , ppVisible           =   dzenColor "white" "#161616" . pad
      , ppHidden            =   dzenColor "white" "#161616" . pad
      , ppHiddenNoWindows   =   dzenColor "#444444" "#161616" . pad
      , ppUrgent            =   dzenColor "white" "red4" . dzenStrip
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#161616" .
                                (\x -> case x of
                                    "Tall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Tall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"             ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "SimplestFloat"    ->      "~"
                                    _                  ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#161616" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook = setDefaultCursor xC_left_ptr >> setWMName "LG3D"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
-- 
myStatusBar = "dzen2 -x '0' -y '0' -w '835'  -h '12' -ta 'l' -fg 'grey' -bg '#161616' -fn '-*-fixed-medium-r-normal-*-10-*-*-*-*-*-*-*'"

main = do
        xmproc <- spawnPipe myStatusBar 
        xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook xmproc,
        startupHook        = myStartupHook
    }
