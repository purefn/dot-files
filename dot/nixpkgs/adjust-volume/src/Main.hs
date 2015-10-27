{-# LANGUAGE OverloadedStrings #-}

import Data.Int
import Data.Maybe
import qualified Data.Text as T
import Options.Applicative
import Turtle hiding (option)
import Libnotify

data Command
  = Inc Int
  | Dec Int
  | Toggle

stepOption :: Parser Int
stepOption = fmap (fromMaybe 5) . optional . option auto . mconcat $
  [ long "step"
  , short 's'
  , metavar "PERCENT"
  , help "Amount to change the volume, default is 5"
  ]

pamixer :: [Text] -> Shell Text
pamixer args = strict . inproc "pamixer" args $ empty

pamixer' :: [Text] -> Shell ()
pamixer' = void . pamixer

opts:: Parser Command
opts = subparser . mconcat $
  [ command "increase" . info (Inc <$> stepOption) $ idm
  , command "decrease" . info (Dec <$> stepOption) $ idm
  , command "toggle" . info (pure Toggle) $ idm
  ]

getVolume :: Shell Int32
getVolume = read . T.unpack . T.strip <$> pamixer ["--get-volume"]

getMuted :: Shell Bool
getMuted = (== "true") . T.unpack . T.strip <$> pamixer ["--get-mute"]

main :: IO ()
main = sh $ do
  command <- liftIO . execParser . info (helper <*> opts) $ idm

  case command of
    Inc s -> pamixer' ["--unmute"] >> pamixer' ["--increase", T.pack .show $ s]
    Dec s -> pamixer' ["--decrease", T.pack .show $ s]
    Toggle -> pamixer' ["--toggle-mute"]

  vol <- getVolume
  muted <- getMuted
  let
    vol' = if muted then 0 else vol
    vicon = case vol' of
      x | x == 0 -> "muted"
      x | x < 33 -> "low"
      x | x < 67 -> "medium"
      _          -> "high"
  liftIO . display_ . mconcat $
    [ summary "Volume"
    , icon ("audio-volume-" <> vicon)
    , hint "value" vol'
    , hint "x-canonical-private-synchronous" ("1" :: String)
    ]

