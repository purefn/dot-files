module Volume (volumeW) where
import PercentBarWidget (
  percentBarWidgetW, percentBarConfig, cycleColors)
import Color as C
import Data.Maybe (fromMaybe)
import System.Environment (getEnv)
import System.Process(readProcess)
import Utils (regexGroups, readProc)
import XMonad.Actions.Volume

mutedColors = map C.rgb [C.Yellow, C.Red] ++ otherColors
unmutedColors = map C.rgb [C.Black, C.Green] ++ otherColors
otherColors = map C.rgb $ C.Blue:(repeat C.Orange)

volumeW = percentBarWidgetW percentBarConfig 0.5 readVolBar

readVolBar = do
  (vol, mute) <- getVolumeMute
  let p = vol/100.0
  let (bg, fg) = cycleColors (if mute then mutedColors else unmutedColors) p
  return (fg, bg, p)
