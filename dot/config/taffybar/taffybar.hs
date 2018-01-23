{-# LANGUAGE ScopedTypeVariables #-}
--
-- Volume widget taken from https://github.com/teleshoes/wolke-home-config
--

import Color (Color(..), hexColor)
import Control.Applicative ((<$>))
import Control.Exception
import Data.List (isPrefixOf)
import Graphics.UI.Gtk.General.RcStyle (rcParseString)
import System.Information.Memory
import System.Information.CPU
import System.Process (readProcess)
import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.CPUMonitor
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.NetMonitor
import System.Taffybar.TaffyPager
import System.Taffybar.Systray
import System.Taffybar.SimpleClock
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

data HostConfig = HostConfig
  { nics :: [String]
  } deriving (Eq, Show)

ronin = HostConfig { nics = [ "eth0", "wlan0" ] }
tealc = HostConfig { nics = [ "wlp3s0" ] }

font = "DejaVu Sans medium 10"
fgColor = hexColor $ RGB (0x93/0xff, 0xa1/0xff, 0xa1/0xff)
bgColor = hexColor $ RGB (0x00/0xff, 0x2b/0xff, 0x36/0xff)
textColor = hexColor Black

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

main = parseRc >> taffybarConfig >>= defaultTaffybar

parseRc = go where
  go = rcParseString $ concat
    [ "style \"default\" {"
    , "  font_name = \"", font, "\""
    , "  bg[NORMAL] = \"", bgColor, "\""
    , "  fg[NORMAL] = \"", fgColor, "\""
    , "  text[NORMAL] = \"", textColor, "\""
    , "}"
    ]

taffybarConfig = cfg where
  cfg = do
    h <- readProcess "hostname" [] ""
    let c = if "ronin" `isPrefixOf` h then ronin else tealc
    return $ cfg' c
  cfg' c = defaultTaffybarConfig
    { startWidgets = start
    , endWidgets = end c
    }
  start = [ taffyPagerNew defaultPagerConfig ]
  end c = reverse . concat $
    [ [ netMonitorNew 0.5 nic | nic <- nics c ]
    , [ cpuMonitorNew cpuCfg 1 "cpu"
      , pollingGraphNew memCfg 1 memCallback
      , batteryBarNew defaultBatteryConfig 0.5
      , systrayNew
      , textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      , weatherNew (defaultWeatherConfig "KIWA") 10
      ]
    ]
  memCfg = defaultGraphConfig
    { graphDataColors = [(1, 0, 0, 1)]
    , graphLabel = Just "mem"
    }
  cpuCfg = defaultGraphConfig
    { graphDataColors =
        [ (0, 1, 0, 1)
        , (1, 0, 1, 0.5)
        ]
    , graphLabel = Just "cpu"
    }
