--
-- Volume widget taken from https://github.com/teleshoes/wolke-home-config
-- 
import System.Taffybar

import System.Taffybar.CPUMonitor
import System.Taffybar.Systray
import System.Taffybar.XMonadLog
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.NetMonitor
import System.Taffybar.Weather
import System.Taffybar.Battery
import System.Taffybar.MPRIS
import System.Taffybar.TaffyPager

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU

import Color (Color(..), hexColor)
import Volume(volumeW)

import Graphics.UI.Gtk.General.RcStyle (rcParseString)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

main = parseRc >> defaultTaffybar cfg where
  parseRc = rcParseString $ concat
    [ "style \"default\" {"
    , "  font_name = \"", font, "\""
    , "  bg[NORMAL] = \"", bgColor, "\""
    , "  fg[NORMAL] = \"", fgColor, "\""
    , "  text[NORMAL] = \"", textColor, "\""
    , "}"
    ]
  font = "Consolas medium 10"
  fgColor = hexColor $ RGB (0x93/0xff, 0xa1/0xff, 0xa1/0xff)
  bgColor = hexColor $ RGB (0x00/0xff, 0x2b/0xff, 0x36/0xff)
  textColor = hexColor $ Black
  cfg = defaultTaffybarConfig 
    { startWidgets = start
    , endWidgets = end
    }
  start = [ taffyPagerNew defaultPagerConfig ]
  end = reverse
    [ netMonitorNew 0.5 "wlp3s0"
    , cpuMonitorNew cpuCfg 1 "cpu"
    , pollingGraphNew memCfg 1 memCallback
--     , batteryBarNew defaultBatteryConfig 30
--     , volumeW
    , systrayNew
    , textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
    , weatherNew (defaultWeatherConfig "KPHX") 10
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
