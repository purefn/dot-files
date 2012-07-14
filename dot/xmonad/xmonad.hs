{-# LANGUAGE DeriveDataTypeable, NoMonomorphismRestriction, TypeSynonymInstances, MultiParamTypeClasses #-}

import XMonad
import XMonad.Core
import XMonad.Actions.GridSelect
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.IM
import XMonad.Layout.Master
import XMonad.Layout.Minimize
import XMonad.Layout.Simplest
import XMonad.StackSet (RationalRect (..), currentTag)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (noBorders,smartBorders,withBorder)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Util.NamedScratchpad
import XMonad.Actions.CycleWS (nextWS, prevWS, toggleWS, toggleOrView)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Scratchpad (scratchpadManageHook, scratchpadSpawnActionCustom)
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO (Handle, hPutStrLn)
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main = do
  (sw, sh)     <- getScreenDim
  workspaceBar <- spawnPipe $ myWorkspaceBar sw sh
  trayerBar    <- spawnPipe myTrayerBar
  topStatusBar <- spawnPipe $ myTopStatusBar sw sh
  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
   {  terminal           = "urxvtc"
    , modMask            = mod4Mask -- Rebind Mod to the Windows key
    , focusFollowsMouse  = True
    , borderWidth        = 1
    , normalBorderColor  = colorGray
    , focusedBorderColor = colorBlue
    , layoutHook         = myLayoutHook
    , workspaces         = myWorkspaces
    , manageHook         = manageDocks <+> myManageHook
    , logHook            = dynamicLogWithPP $ myDzenPP workspaceBar
    , keys               = myKeys
    , startupHook        = ewmhDesktopsStartup >> setWMName "LG3D"
    , handleEventHook    = minimizeEventHook
    }

getScreenDim = do
    d <- openDisplay ""
    let s = defaultScreen d
        w = displayWidth d s
        h = displayHeight d s
    closeDisplay d
    return (toInteger w, toInteger h)

-- Colors
--myFont              = "-misc-fixed-medium-r-semicondensed-*-12-110-75-75-c-60-*-*"
myFont              = "DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true"
--dzenFont            = "-*-montecarlo-medium-r-normal-*-11-*-*-*-*-*-*-*"
dzenFont            = "DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true"
--dzenFont            = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
--dzenFont            = "Anonymous Pro:size=11"
colorBlack          = "#000000"
colorBlackAlt       = "#050505"
colorGray           = "#484848"
colorGrayAlt        = "#b8bcb8"
colorDarkGray       = "#161616"
colorWhite          = "#ffffff"
colorWhiteAlt       = "#9d9d9d"
colorDarkWhite      = "#444444"
colorMagenta        = "#8e82a2"
colorMagentaAlt     = "#a488d9"
colorBlue           = "#60a0c0"
colorBlueAlt        = "#007b8c"
colorRed            = "#d74b73"
icons               = "/home/rwallace/.icons/subtle/"

-- Tab theme
myTabTheme = defaultTheme
  { fontName            = myFont
  , inactiveBorderColor = colorGrayAlt
  , inactiveColor       = colorGray
  , inactiveTextColor   = colorGrayAlt
  , activeBorderColor   = colorGrayAlt
  , activeColor         = colorBlue
  , activeTextColor     = colorDarkGray
  , urgentBorderColor   = colorBlackAlt
  , urgentTextColor     = colorWhite
  , decoHeight          = 14
  }

-- Prompt theme
myXPConfig = defaultXPConfig
  { font                = myFont
  , bgColor             = colorBlackAlt
  , fgColor             = colorWhiteAlt
  , bgHLight            = colorBlue
  , fgHLight            = colorDarkGray
  , borderColor         = colorDarkGray
  , promptBorderWidth   = 1
  , height              = 16
  , position            = Top
  , historySize         = 100
  , historyFilter       = deleteConsecutive
  , autoComplete        = Nothing
  }

-- GridSelect magenta color scheme
myColorizer = colorRangeFromClassName
    (0x00,0x00,0x00) -- lowest inactive bg
    (0xBB,0xAA,0xFF) -- highest inactive bg
    (0x88,0x66,0xAA) -- active bg
    (0xBB,0xBB,0xBB) -- inactive fg
    (0x00,0x00,0x00) -- active fg
--	where
--	    black = minBound
--	    white = maxBound
 
-- GridSelect theme
myGSConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 50
    , gs_cellwidth    = 200
    , gs_cellpadding  = 10
    , gs_font         = myFont
    }
 
-- Scratchpad
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect (0) (1/50) (1) (3/4))
scratchPad = scratchpadSpawnActionCustom "urxvtc -name scratchpad -e tmux"

-- Transformers
data TABBED = TABBED deriving (Read, Show, Eq, Typeable)
instance Transformer TABBED Window where
     transform TABBED x k = k (named "TS" (smartBorders (tabbedAlways shrinkText myTabTheme))) (\_ -> x)
 
-- StatusBars
myWorkspaceBar, myTopStatusBar :: Integer -> Integer -> String 
myWorkspaceBar w h = "dzen2 -x '0' -y '" ++ show (h - 16) ++ "' -h '16' -w '" ++ show (floor $ toRational w * 0.9) ++ "' -ta 'l' -fg '" ++ colorWhite ++ "' -bg '" ++ colorBlackAlt ++ "' -fn '" ++ dzenFont ++ "' -p -e ''"
myTopStatusBar w h = "/home/rwallace/.xmonad/topstatusbar.sh '" ++ show w ++ "' '" ++ dzenFont ++ "'"
myTrayerBar    = "/home/rwallace/.xmonad/trayerbar.sh"

myLayoutHook = id
        $ gaps [(U,12), (D,12), (L,0), (R,0)]
        $ avoidStruts
        $ minimize
        $ mkToggle (single TABBED)
        $ mkToggle (single REFLECTX)
        $ mkToggle (single REFLECTY)
        $ onWorkspace (myWorkspaces !! 0) termLayouts  --Workspace 0 layouts
        $ onWorkspace (myWorkspaces !! 1) webLayouts   --Workspace 1 layouts
	$ onWorkspace (myWorkspaces !! 2) codeLayouts  --Workspace 2 layouts
	$ onWorkspace (myWorkspaces !! 3) gimpLayouts  --Workspace 3 layouts
	$ onWorkspace (myWorkspaces !! 4) chatLayouts  --Workspace 4 layouts
        $ onWorkspace (myWorkspaces !! 6) (noBorders Simplest)
        $ allLayouts
	where
		allLayouts  = myTile ||| myTabS ||| myTabM ||| myTabC
		--allLayouts  = layoutHook defaultConfig
		termLayouts = myTile ||| myTabC ||| myTabM
		--termLayouts = allLayouts
		webLayouts  = myTabS ||| myTabM
		--webLayouts  = allLayouts
		codeLayouts = myTabM ||| myTile
		--codeLayouts = allLayouts
		gimpLayouts = myGfxT ||| myGfxMT
		--gimpLayouts = allLayouts
		chatLayouts = myChat
		--chatLayouts = allLayouts
		--Layouts
		myTile   = named "T"  (smartBorders (ResizableTall 1 0.03 0.5 []))
		myTabC   = named "TC" (smartBorders (mastered 0.01 0.4 $ (Mirror (ResizableTall 1 0.03 0.5 []))))
		myTabS   = named "TS" (smartBorders (tabbed shrinkText myTabTheme))
		myTabM   = named "TM" (smartBorders (mastered 0.01 0.4 $ (tabbed shrinkText myTabTheme)))
		myGfxT   = named "GT" (withIM (0.15) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.20) (Role "gimp-dock") (myTabS))
		myGfxMT  = named "GM" (withIM (0.15) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.20) (Role "gimp-dock") (Mirror myTile))
		myChat   = named "C"  (withIM (0.20) (Title "Buddy List") $ Mirror myTile)

myWorkspaces ::[WorkspaceId]
myWorkspaces = clickable $
        ["^i(" ++ icons ++ "terminal.xbm) term"    --0
        ,"^i(" ++ icons ++ "world.xbm) web"        --1
        ,"^i(" ++ icons ++ "binder.xbm) code"      --2
        ,"^i(" ++ icons ++ "mouse.xbm) gfx"        --3
        ,"^i(" ++ icons ++ "balloon.xbm) chat"     --4
        ,"^i(" ++ icons ++ "headphones.xbm) music" --5
        ,"^i(" ++ icons ++ "screen.xbm) video"     --6
        ,"^i(" ++ icons ++ "ghost.xbm) other"      --7
        ]
        where clickable l = [ " ^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca() " |
        --where clickable l = [ show (n) ++ ws |
                (i, ws) <- zip [1..] l,
                let n = if i == 10 then 0 else i ]

myManageHook :: ManageHook
myManageHook = (composeAll . concat $
        [ [resource     =? r --> doIgnore                    | r <- myIgnores] --ignore desktop
        , [className    =? c --> doShift (myWorkspaces !! 1) | c <- myWebS   ] --move myWebS windows to workspace 1 by classname
	, [className    =? c --> doShift (myWorkspaces !! 4) | c <- myChatS  ] --move myChatS windows to workspace 4 by classname
	, [className    =? c --> doShift (myWorkspaces !! 3) | c <- myGfxS   ] --move myGfxS windows to workspace 4 by classname
	, [className    =? c --> doShift (myWorkspaces !! 5) | c <- myMusicS ] --move myMusiS windows to workspace 5 by classname
	, [className    =? c --> doCenterFloat               | c <- myFloatCC] --float center geometry by classname
	, [name         =? n --> doCenterFloat               | n <- myFloatCN] --float center geometry by name
	, [name         =? n --> doSideFloat NW              | n <- myFloatSN] --float side NW geometry by name
	, [className    =? c --> doF W.focusDown             | c <- myFocusDC] --dont focus on launching by classname
	, [isFullscreen      --> doF W.focusDown <+> doFullFloat]
	]) <+> manageScratchPad
	where
		role      = stringProperty "WM_WINDOW_ROLE"
		name      = stringProperty "WM_NAME"
		myIgnores = ["desktop","desktop_window"]
		myWebS    = ["Chromium","Firefox"]
		myGfxS    = ["gimp-2.6", "Gimp-2.6", "Gimp", "gimp", "GIMP"]
		myChatS   = ["Pidgin", "Xchat"]
		myMusicS  = ["Clementine"]
		myFloatCC = ["MPlayer", "File-roller", "zsnes", "Gcalctool", "Exo-helper-1"]
		myFloatCN = ["ePSXe - Enhanced PSX emulator", "Seleccione Archivo", "Config Video", "Testing plugin", "Config Sound", "Config Cdrom", "Config Bios", "Config Netplay", "Config Memcards", "About ePSXe", "Config Controller", "Config Gamepads", "Select one or more files to open", "Add media", "Choose a file", "Open Image", "File Operation Progress", "Firefox Preferences", "Preferences", "Search Engines", "Set up sync", "Passwords and Exceptions", "Autofill Options", "Rename File", "Copying files", "Moving files", "File Properties", "Replace", ""]
		myFloatSN = ["Event Tester"]
		myFocusDC = ["Event Tester"]

-- myWorkspaceBar config
myDzenPP h = defaultPP
  { ppOutput          = hPutStrLn h
  , ppSep             = ""
  , ppWsSep           = ""
  , ppCurrent         = wrap ("^fg(" ++ colorWhite ++ ")^bg(" ++ colorBlue ++ ")") ("^fg()^bg()")
  , ppUrgent          = wrap ("^fg(" ++ colorWhite ++ ")^bg(" ++ colorRed ++ ")") ("^fg()^bg()")
  , ppVisible         = wrap ("^fg(" ++ colorWhite ++ ")^bg(" ++ colorGray ++ ")") ("^fg()^bg()")
  , ppHidden          = wrap ("^fg(" ++ colorGrayAlt ++ ")^bg(" ++ colorGray ++ ")") ("^fg()^bg()")
  , ppSort            = fmap (namedScratchpadFilterOutWorkspace.) (ppSort xmobarPP) -- hide "NSP" from the workspace list
  , ppHiddenNoWindows = wrap ("^fg(" ++ colorGray ++ ")^bg(" ++ colorBlackAlt ++ ")") ("^fg()^bg()")
  , ppTitle           = wrap ("^fg(" ++ colorWhiteAlt ++ ")^bg(" ++ colorBlackAlt ++ ")") ("^fg()^bg()") . wrap "" " ^fg(#a488d9)>^fg(#007b8c)>^fg(#444444)>"
--  , ppLayout          = wrap ("^fg(" ++ colorBlue ++ ")^bg(" ++ colorBlackAlt ++ ")") ("^fg()^bg()") .
--    (\x -> case x of
--      "Minimize T"                    -> " ^i(/home/nnoell/.icons/xbm8x8/tall.xbm) "
--      "Minimize TS"                   -> " ^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize TM"                   -> " ^i(/home/nnoell/.icons/xbm8x8/tab2.xbm) "
--      "Minimize TC"                   -> " ^i(/home/nnoell/.icons/xbm8x8/tab3.xbm) "
--      "Minimize GT"                   -> " ^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize GM"                   -> " ^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize C"                    -> " ^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectX T"           -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/tall.xbm) "
--      "Minimize ReflectX TS"          -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectX TM"          -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/tab2.xbm) "
--      "Minimize ReflectX TC"          -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/tab3.xbm) "
--      "Minimize ReflectX GT"          -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectX GM"          -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectX C"           -> " ^fg(#007b8c)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectY T"           -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/tall.xbm) "
--      "Minimize ReflectY TS"          -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectY TM"          -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/tab2.xbm) "
--      "Minimize ReflectY TC"          -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/tab3.xbm) "
--      "Minimize ReflectY GT"          -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectY GM"          -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectY C"           -> " ^fg(#444444)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectX ReflectY T"  -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/tall.xbm) "
--      "Minimize ReflectX ReflectY TS" -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectX ReflectY TM" -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/tab2.xbm) "
--      "Minimize ReflectX ReflectY TC" -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/tab3.xbm) "
--      "Minimize ReflectX ReflectY GT" -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/tab1.xbm) "
--      "Minimize ReflectX ReflectY GM" -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--      "Minimize ReflectX ReflectY C"  -> " ^fg(#d74b73)^i(/home/nnoell/.icons/xbm8x8/mtall.xbm) "
--    )
  }

-- Key bindings
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
	[ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)                       --Launch a terminal
	, ((modMask, xK_p), spawn "dmenu_run")                                                     --Launch dmenu
	, ((mod1Mask, xK_F2), shellPrompt myXPConfig)                                              --Launch Xmonad shell prompt
	, ((modMask .|. shiftMask, xK_F2), xmonadPrompt myXPConfig)                                --Launch Xmonad prompt
	, ((modMask, xK_g), goToSelected $ myGSConfig myColorizer)                                 --Launch GridSelect
	, ((modMask, xK_masculine), scratchPad)                                                    --Scratchpad
        , ((modMask .|. shiftMask, xK_s), spawn "gksu ~/bin/suspend")                                            --Suspend
	, ((modMask, xK_o), spawn "gksu halt")                                                     --Power off
	, ((modMask .|. shiftMask, xK_o), spawn "gksu reboot")                                     --Reboot
	, ((mod1Mask, xK_F3), spawn "chromium")                                                    --Launch chromium
	, ((modMask, xK_c), kill)                                                                  --Close focused window
	, ((mod1Mask, xK_F4), kill)
	, ((modMask, xK_space), sendMessage NextLayout)                                            --Rotate through the available layout algorithms
	, ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)                 --Reset the layouts on the current workspace to default
	, ((modMask, xK_n), refresh)                                                               --Resize viewed windows to the correct size
	, ((modMask, xK_Tab), windows W.focusDown)												   --Move focus to the next window
	, ((modMask, xK_j), windows W.focusDown)
	, ((mod1Mask, xK_Tab), windows W.focusDown)
	, ((modMask, xK_k), windows W.focusUp)                                                     --Move focus to the previous window
	, ((modMask, xK_a), windows W.focusMaster)                                                 --Move focus to the master window
	, ((modMask .|. shiftMask, xK_a), windows W.swapMaster)                                    --Swap the focused window and the master window
	, ((modMask .|. shiftMask, xK_j), windows W.swapDown  )                                    --Swap the focused window with the next window
	, ((modMask .|. shiftMask, xK_k), windows W.swapUp    )                                    --Swap the focused window with the previous window
	, ((modMask, xK_h), sendMessage Shrink)                                                    --Shrink the master area
	, ((modMask .|. shiftMask, xK_Left), sendMessage Shrink)
	, ((modMask, xK_l), sendMessage Expand)                                                    --Expand the master area
	, ((modMask .|. shiftMask, xK_Right), sendMessage Expand)
	, ((modMask .|. shiftMask, xK_h), sendMessage MirrorShrink)                                --MirrorShrink the master area
	, ((modMask .|. shiftMask, xK_Down), sendMessage MirrorShrink)
	, ((modMask .|. shiftMask, xK_l), sendMessage MirrorExpand)                                --MirrorExpand the master area
	, ((modMask .|. shiftMask, xK_Up), sendMessage MirrorExpand)
	, ((modMask, xK_t), withFocused $ windows . W.sink)                                        --Push window back into tiling
	, ((modMask .|. shiftMask, xK_t), rectFloatFocused)                                        --Push window into float
	, ((modMask, xK_f), sendMessage $ XMonad.Layout.MultiToggle.Toggle TABBED)                 --Push layout into tabbed
	, ((modMask .|. shiftMask, xK_x), sendMessage $ XMonad.Layout.MultiToggle.Toggle REFLECTX) --Reflect layout by X
	, ((modMask .|. shiftMask, xK_y), sendMessage $ XMonad.Layout.MultiToggle.Toggle REFLECTY) --Reflect layout by Y
	, ((modMask, xK_m), withFocused minimizeWindow)                                            --Minimize window
	, ((modMask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)                     --Restore window
	, ((modMask .|. shiftMask, xK_f), fullFloatFocused)                                        --Push window into full screen
	, ((modMask, xK_comma), sendMessage (IncMasterN 1))                                        --Increment the number of windows in the master area
	, ((modMask, xK_period), sendMessage (IncMasterN (-1)))                                    --Deincrement the number of windows in the master area
	, ((modMask , xK_d), spawn "killall dzen2 trayer")                                         --Kill dzen2 and trayer
	, ((modMask , xK_s), spawn "xscreensaver-command -lock")                                   --Lock screen
	, ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))                               --Quit xmonad
	, ((modMask, xK_q), restart "xmonad" True)                                                 --Restart xmonad
	, ((modMask, xK_comma), toggleWS)                                                          --Toggle to the workspace displayed previously
	, ((mod1Mask, xK_masculine), toggleOrView (myWorkspaces !! 0))                             --Move to Workspace 0
	, ((mod1Mask .|. controlMask, xK_Left),  prevWS)                                           --Move to previous Workspace
	, ((modMask, xK_Left), prevWS)
	, ((modMask, xK_Right), nextWS)                                                            --Move to next Workspace
	, ((mod1Mask .|. controlMask, xK_Right), nextWS)
	, ((0, xF86XK_AudioMute), toggleMute >> return ())                                         --Mute/unmute volume
	, ((0, xF86XK_AudioRaiseVolume), setMute False >> raiseVolume 10 >> return ())              --Raise volume
	, ((0, xF86XK_AudioLowerVolume), setMute False >> lowerVolume 10 >> return ())              --Lower volume
	, ((0, xF86XK_MonBrightnessUp), spawn "sh /home/nnoell/.scripts/briosd.sh")                --Raise brightness
	, ((0, xF86XK_MonBrightnessDown), spawn "sh /home/nnoell/.scripts/briosd.sh")              --Lower brightness
	, ((0, xF86XK_ScreenSaver), spawn "xscreensaver-command -lock")                            --Lock screen
	, ((0, xK_Print), spawn "scrot")                                                           --Take a screenshot
	]
	++
	[((m .|. modMask, k), windows $ f i)                                                       --Switch to n workspaces and send client to n workspaces
	  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
	  , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
	++
	[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))                --Switch to n screens and send client to n screens
	  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
	  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
	where
		fullFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery doFullFloat f
		rectFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery (doRectFloat $ RationalRect 0.05 0.05 0.9 0.9) f

