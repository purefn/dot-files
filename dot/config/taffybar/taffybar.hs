{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.List (isPrefixOf)
import Data.Maybe
import Data.Monoid
import System.Log.Handler.Simple
import System.Log.Logger
import System.Process (readProcess)
import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Battery
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Generic.PollingLabel
import System.Taffybar.Widget.Text.NetworkMonitor
import System.Taffybar.Widget.SNITray
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces

data HostConfig = HostConfig
  { nics :: [String]
  } deriving (Eq, Show)

ronin = HostConfig { nics = [ "enp59s0", "wlp61s0" ] }
tealc = HostConfig { nics = [ "wlp3s0" ] }

mkRGBA (r, g, b, a) = (r/256, g/256, b/256, a/256)
blue = mkRGBA (42, 99, 140, 256)
yellow1 = mkRGBA (242, 163, 54, 256)
yellow2 = mkRGBA (254, 204, 83, 256)
yellow3 = mkRGBA (227, 134, 18, 256)
red = mkRGBA (210, 77, 37, 256)

myGraphConfig =
  defaultGraphConfig
  { graphPadding = 0
  , graphBorderWidth = 0
  , graphWidth = 75
  , graphBackgroundColor = (0.0, 0.0, 0.0, 0.0)
  }

-- netCfg i = myGraphConfig
--   { graphDataColors = [yellow1, yellow2]
--   , graphLabel = Just i
--   }

memCfg = myGraphConfig
  { graphDataColors = [(0.129, 0.588, 0.953, 1)]
  , graphLabel = Just "mem"
  }

cpuCfg = myGraphConfig
  { graphDataColors = [(0, 1, 0, 1), (1, 0, 1, 0.5)]
  , graphLabel = Just "cpu"
  }

memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

enableLogger logger level = do
  logger <- getLogger logger
  saveGlobalLogger $ setLevel level logger

logDebug = do
  logger <- getLogger "System.Taffybar.Widget.Generic.AutoSizeImage"
  saveGlobalLogger $ setLevel DEBUG logger
  logger2 <- getLogger "StatusNotifier.Tray"
  saveGlobalLogger $ setLevel DEBUG logger2
  workspacesLogger <- getLogger "System.Taffybar.Widget.Workspaces"
  saveGlobalLogger $ setLevel WARNING workspacesLogger

main = do
  host <- readProcess "hostname" [] ""
  let
    hostConfig = if "ronin" `isPrefixOf` host then ronin else tealc
    cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
    mem = pollingGraphNew memCfg 1 memCallback
    -- nets = fmap (\i -> networkGraphNew (netCfg i) (Just [i])) (nics hostConfig)
    nets = fmap (\i -> networkMonitorNew (i <> " " <> defaultNetFormat) (Just [i])) (nics hostConfig)
    clock = textClockNew Nothing "%a %b %_d %H:%M" 1
    layout = layoutNew defaultLayoutConfig
    windows = windowsNew defaultWindowsConfig
    tray = sniTrayNew
    myWorkspacesConfig = defaultWorkspacesConfig
      { underlineHeight = 0
      , underlinePadding = 0
      , minIcons = 0
      , maxIcons = Just 0
      , getWindowIconPixbuf = scaledWindowIconPixbufGetter getWindowIconPixbufFromEWMH
      -- , maxIcons = Just 1
      , borderWidth = 0
      }
    workspaces = workspacesNew myWorkspacesConfig
    myConfig = defaultSimpleTaffyConfig
      { startWidgets =
          workspaces : map (>>= buildContentsBox) [ layout, windows ]
      , endWidgets = map (>>= buildContentsBox) . mconcat $
        [ [ clock
          -- , textBatteryNew "$status$ $percentage$% ($time$)"
          , tray
          , cpu
          , mem
          ]
        , nets
        ]
      , barPosition = Top
      , barPadding = 0
      , barHeight = 50
      , widgetSpacing = 0
      }
  dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $
               toTaffyConfig myConfig
