{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeSynonymInstances #-}

import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO (Handle, hPutStrLn)
import System.Taffybar.Support.PagerHints (pagerHints)
import XMonad
import XMonad.Core
import XMonad.Actions.CycleWS (nextWS, prevWS, toggleWS, toggleOrView)
import XMonad.Actions.GridSelect
import XMonad.Actions.Minimize
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.SetWMName
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.IM
import XMonad.Layout.Master
import XMonad.Layout.Minimize
import XMonad.Layout.Simplest
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
import XMonad.StackSet (RationalRect (..), currentTag)
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Scratchpad (scratchpadManageHook, scratchpadSpawnActionCustom)

-- main = xmonad . swingFix . docks . ewmh $ defaultConfig
main = xmonad . docks . ewmh . pagerHints $ def
  { borderWidth        = 1
  , focusedBorderColor = colorBlue
  , focusFollowsMouse  = True
  , handleEventHook    = minimizeEventHook
  , keys               = myKeys
  , layoutHook         = myLayoutHook
  , manageHook         = manageDocks <+> myManageHook
  , modMask            = mod4Mask -- Rebind Mod to the Windows key
  , normalBorderColor  = colorGray
  , terminal           = "kitty"
  , workspaces         = myWorkspaces
  }

-- Java swing apps will just display a grey screen without this
-- swingFix c = c { startupHook = startupHook c <> setWMName "LG3D" }

-- Colors
-- myFont              = "Ubuntu Mono:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Unifont:pixelsize=14"
-- myFont              = "Inconsolata:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "monofur:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Consolas:pixelsize=12:antialias=true:autohinting=true,Unifont:pixelsize=12"
-- myFont              = "Monaco:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Anonymous Pro:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Droid Sans Mono:pixelsize=12:antialias=true:hinting=true"
myFont = "monospace"

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
-- icons               = "/home/rwallace/.icons/subtle/"

-- Tab theme
myTabTheme = def
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
myXPConfig = def
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
--  where
--      black = minBound
--      white = maxBound

-- GridSelect theme
myGSConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 50
    , gs_cellwidth    = 200
    , gs_cellpadding  = 10
    , gs_font         = myFont
    }

-- Scratchpad
-- manageScratchPad :: ManageHook
-- manageScratchPad = scratchpadManageHook (W.RationalRect 0 (1/50) 1 (3/4))
-- scratchPad = scratchpadSpawnActionCustom "urxvtc -name scratchpad -e tmux"

-- Transformers
data TABBED = TABBED deriving (Read, Show, Eq, Typeable)
instance Transformer TABBED Window where
  transform TABBED x k = k (named "TS" (smartBorders (tabbedAlways shrinkText myTabTheme))) (const x)

myLayoutHook = minimize layouts where
  basicLayout = Tall nmaster delta ratio where
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2
  tallLayout       = named "T"     $ avoidStruts basicLayout
  wideLayout       = named "W"     $ avoidStruts $ Mirror basicLayout
  singleLayout     = named "S"     $ avoidStruts $ tabbed shrinkText myTabTheme
  all = tallLayout ||| wideLayout ||| singleLayout
  layouts = onWorkspace "web" singleLayout $ onWorkspace "chat" singleLayout $ all

myWorkspaces ::[WorkspaceId]
myWorkspaces = [ "term", "web", "code", "gfx", "chat", "music", "video", "other" ]

myManageHook :: ManageHook
myManageHook = hooks where
  hooks = composeAll . concat $
    [ [resource     =? r --> doIgnore                    | r <- myIgnores] --ignore desktop
    , [className    =? c --> doShift (myWorkspaces !! 1) | c <- myWebS   ] --move myWebS windows to workspace 1 by classname
    , [className    =? c --> doShift (myWorkspaces !! 3) | c <- myGfxS   ] --move myGfxS windows to workspace 3 by classname
    , [className    =? c --> doShift (myWorkspaces !! 4) | c <- myChatS  ] --move myChatS windows to workspace 4 by classname
    , [className    =? c --> doShift (myWorkspaces !! 5) | c <- myMusicS ] --move myMusiS windows to workspace 5 by classname
    , [className    =? c --> doCenterFloat               | c <- myFloatCC] --float center geometry by classname
    , [name         =? n --> doCenterFloat               | n <- myFloatCN] --float center geometry by name
    , [name         =? n --> doSideFloat NW              | n <- myFloatSN] --float side NW geometry by name
    , [className    =? c --> doF W.focusDown             | c <- myFocusDC] --dont focus on launching by classname
    , [isFullscreen      --> doF W.focusDown <+> doFullFloat]
    , [className    =? c --> doSink                      | c <- mySink   ] --force these windwos to tiling
    ]
  role      = stringProperty "WM_WINDOW_ROLE"
  name      = stringProperty "WM_NAME"
  myIgnores = ["desktop","desktop_window"]
  myWebS    = ["Chromium","Firefox","Deluge"]
  myGfxS    = ["gimp-2.6", "Gimp-2.6", "Gimp", "gimp", "GIMP"]
  myChatS   = ["Pidgin", "Xchat", "HipChat", "discord"]
  myMusicS  = ["Clementine", "Pithos", "Spotify"]
  myFloatCC = ["MPlayer", "File-roller", "zsnes", "Gcalctool", "Exo-helper-1"]
  myFloatCN = ["ePSXe - Enhanced PSX emulator", "Seleccione Archivo", "Config Video", "Testing plugin", "Config Sound", "Config Cdrom", "Config Bios", "Config Netplay", "Config Memcards", "About ePSXe", "Config Controller", "Config Gamepads", "Select one or more files to open", "Add media", "Choose a file", "Open Image", "File Operation Progress", "Firefox Preferences", "Preferences", "Search Engines", "Set up sync", "Passwords and Exceptions", "Autofill Options", "Rename File", "Copying files", "Moving files", "File Properties", "Replace", ""]
  myFloatSN = ["Event Tester"]
  myFocusDC = ["Event Tester"]
  mySink    = ["HipChat"]
  doSink = doF . W.sink =<< ask

-- Key bindings
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)                       --Launch a terminal
  , ((modMask, xK_p), spawn "rofi -show run")                                                -- Launch rofi run prompt
  , ((modMask, xK_g), goToSelected $ myGSConfig myColorizer)                                 --Launch GridSelect
  , ((modMask, xK_c), kill)                                                                  --Close focused window
  , ((modMask, xK_space), sendMessage NextLayout)                                            --Rotate through the available layout algorithms
  , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)                 --Reset the layouts on the current workspace to default
  , ((modMask, xK_n), refresh)                                                               --Resize viewed windows to the correct size
  , ((modMask, xK_Tab), windows W.focusDown)                           --Move focus to the next window
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
  , ((modMask .|. shiftMask, xK_m), withLastMinimized maximizeWindowAndFocus)                --Restore window
  , ((modMask .|. shiftMask, xK_f), fullFloatFocused)                                        --Push window into full screen
  , ((modMask, xK_s), spawn "betterlockscreen --lock --dim 95")                                   --Lock screen
  , ((modMask .|. shiftMask, xK_q), io exitSuccess)                               --Quit xmonad
  , ((modMask, xK_q), restart "xmonad" True)                                                 --Restart xmonad
  , ((modMask, xK_Left), prevWS)
  , ((modMask, xK_Right), nextWS)                                                            --Move to next Workspace
  , ((0, xF86XK_ScreenSaver), spawn "betterlockscreen --lock --dim 95")                            --Lock screen
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
  , ((0, xF86XK_AudioMute), spawn "adjust-volume toggle")
  , ((0, xF86XK_AudioRaiseVolume), spawn "adjust-volume increase")
  , ((0, xF86XK_AudioLowerVolume), spawn "adjust-volume decrease")
  ]
  ++
  [((m .|. modMask, k), windows $ f i)                                                       --Switch to n workspaces and send client to n workspaces
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))                --Switch to n screens and send client to n screens
    | (key, sc) <- zip [xK_r, xK_w, xK_e] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  where
    fullFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery doFullFloat f
    rectFloatFocused = withFocused $ \f -> windows =<< appEndo `fmap` runQuery (doRectFloat $ RationalRect 0.05 0.05 0.9 0.9) f

