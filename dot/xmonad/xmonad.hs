{-# LANGUAGE DeriveDataTypeable, NoMonomorphismRestriction, TypeSynonymInstances, MultiParamTypeClasses #-}

import XMonad
import XMonad.Core
import XMonad.Actions.GridSelect
import XMonad.Actions.Volume
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
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

import System.Taffybar.Hooks.PagerHints (pagerHints)

main = xmonad $ ewmh $ defaultConfig
  { borderWidth        = 1
  , focusedBorderColor = colorBlue
  , focusFollowsMouse  = True
  , handleEventHook    = minimizeEventHook
  , keys               = myKeys
  , layoutHook         = myLayoutHook
  , manageHook         = manageDocks <+> myManageHook
  , modMask            = mod4Mask -- Rebind Mod to the Windows key
  , normalBorderColor  = colorGray
  , startupHook        = spawn "/home/rwallace/.xmonad/topstatusbar.sh"
  , terminal           = "urxvtc"
  , workspaces         = myWorkspaces
  }

-- Colors
-- myFont              = "Ubuntu Mono:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Unifont:pixelsize=14"
-- myFont              = "Inconsolata:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "monofur:pixelsize=12:antialias=true:hinting=true"
myFont              = "Consolas:pixelsize=12:antialias=true:autohinting=true,Unifont:pixelsize=12"
-- myFont              = "Monaco:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Anonymous Pro:pixelsize=12:antialias=true:hinting=true"
-- myFont              = "Droid Sans Mono:pixelsize=12:antialias=true:hinting=true"

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
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect 0 (1/50) 1 (3/4))
scratchPad = scratchpadSpawnActionCustom "urxvtc -name scratchpad -e tmux"

-- Transformers
data TABBED = TABBED deriving (Read, Show, Eq, Typeable)
instance Transformer TABBED Window where
  transform TABBED x k = k (named "TS" (smartBorders (tabbedAlways shrinkText myTabTheme))) (const x)
 
myLayoutHook = minimize layouts where
  basicLayout = Tall nmaster delta ratio where
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2 
  tallLayout       = named "tall"     $ avoidStruts basicLayout
  wideLayout       = named "wide"     $ avoidStruts $ Mirror basicLayout
  singleLayout     = named "single"   $ avoidStruts $ tabbed shrinkText myTabTheme
  layouts = tallLayout 
        ||| wideLayout
        ||| singleLayout
--         ||| circleLayout 
--         ||| twoPaneLayout 
--         ||| mosaicLayout
--         ||| gridLayout
--         ||| spiralLayout
--         $ gaps [(U,12), (D,12), (L,0), (R,0)]
--         $ avoidStruts
--         $ minimize
--         $ mkToggle (single TABBED)
--         $ mkToggle (single REFLECTX)
--         $ mkToggle (single REFLECTY)
--         $ onWorkspace (myWorkspaces !! 0) termLayouts  --Workspace 0 layouts
--         $ onWorkspace (myWorkspaces !! 1) webLayouts   --Workspace 1 layouts
--   $ onWorkspace (myWorkspaces !! 2) codeLayouts  --Workspace 2 layouts
--   $ onWorkspace (myWorkspaces !! 3) gimpLayouts  --Workspace 3 layouts
--   $ onWorkspace (myWorkspaces !! 4) chatLayouts  --Workspace 4 layouts
--         $ onWorkspace (myWorkspaces !! 6) (noBorders Simplest)
--         $ allLayouts
--   where
--     allLayouts  = myTile ||| myTabS ||| myTabM ||| myTabC
--     --allLayouts  = layoutHook defaultConfig
--     termLayouts = myTile ||| myTabC ||| myTabM
--     --termLayouts = allLayouts
--     webLayouts  = myTabS ||| myTabM
--     --webLayouts  = allLayouts
--     codeLayouts = myTabM ||| myTile
--     --codeLayouts = allLayouts
--     chatLayouts = myChat
--     --chatLayouts = allLayouts
--     --Layouts
--     myTile   = named "T"  (smartBorders (ResizableTall 1 0.03 0.5 []))
--     myTabC   = named "TC" (smartBorders (mastered 0.01 0.4 $ (Mirror (ResizableTall 1 0.03 0.5 []))))
--     myTabS   = named "TS" (smartBorders (tabbed shrinkText myTabTheme))
--     myTabM   = named "TM" (smartBorders (mastered 0.01 0.4 $ (tabbed shrinkText myTabTheme)))
--     myGfxT   = named "GT" (withIM (0.15) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.20) (Role "gimp-dock") (myTabS))
--     myGfxMT  = named "GM" (withIM (0.15) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.20) (Role "gimp-dock") (Mirror myTile))
--     myChat   = named "C"  (withIM (0.20) (Title "Buddy List") $ Mirror myTile)

myWorkspaces ::[WorkspaceId]
myWorkspaces = [ "term", "web", "code", "gfx", "chat", "music", "video", "other" ]

myManageHook :: ManageHook
myManageHook = hooks <+> manageScratchPad where
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
    ] 
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

-- Key bindings
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)                       --Launch a terminal
  , ((modMask, xK_p), shellPrompt myXPConfig)                                              --Launch Xmonad shell prompt
  , ((modMask, xK_g), goToSelected $ myGSConfig myColorizer)                                 --Launch GridSelect
  , ((modMask, xK_masculine), scratchPad)                                                    --Scratchpad
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
  , ((modMask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin)                     --Restore window
  , ((modMask .|. shiftMask, xK_f), fullFloatFocused)                                        --Push window into full screen
  , ((modMask, xK_s), spawn "xscreensaver-command -lock")                                   --Lock screen
  , ((modMask .|. shiftMask, xK_q), io exitSuccess)                               --Quit xmonad
  , ((modMask, xK_q), restart "xmonad" True)                                                 --Restart xmonad
  , ((modMask, xK_Left), prevWS)
  , ((modMask, xK_Right), nextWS)                                                            --Move to next Workspace
  -- , ((0, xF86XK_AudioMute), toggleMute')
  -- , ((0, xF86XK_AudioRaiseVolume), raiseVolume')
  -- , ((0, xF86XK_AudioLowerVolume), lowerVolume')
  , ((0, xF86XK_ScreenSaver), spawn "xscreensaver-command -lock")                            --Lock screen
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

raiseVolume' = do
  setMute False
  raiseVolume 10
  return ()

lowerVolume' = do
  setMute False
  lowerVolume 10
  return ()

toggleMute' = toggleMute >> return ()
