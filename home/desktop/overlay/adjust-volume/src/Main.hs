{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

import Control.Exception
import Data.Int
import Data.Maybe
import qualified Data.Text as T
import Options.Applicative
import Turtle hiding (option)

import Debug.Trace

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

pamixer :: [Text] -> Shell (ExitCode, Text)
pamixer args = procStrict "pamixer" args $ empty

pamixer' :: [Text] -> Shell ()
pamixer' = void . pamixer

opts:: Parser Command
opts = subparser . mconcat $
  [ command "increase" . info (Inc <$> stepOption) $ idm
  , command "decrease" . info (Dec <$> stepOption) $ idm
  , command "toggle" . info (pure Toggle) $ idm
  ]

getVolume :: Shell Int32
getVolume = pamixer ["--get-volume"] >>= \case
  (exitCode@(ExitFailure _), _) -> liftIO . throwIO $ exitCode
  (_, output) -> pure . read . T.unpack . T.strip $ output

getMuted :: Shell Bool
getMuted = pamixer ["--get-mute"] >>= \case
  (ExitFailure 1, output) -> parseMute output
  (exitCode@(ExitFailure _), _) -> liftIO . throwIO $ exitCode
  (_, output) -> parseMute output
  where
    parseMute = pure . (== "true") . traceShowId . T.strip

main :: IO ()
main = sh $ do
  command <- liftIO . execParser . info (helper <*> opts) $ idm

  case command of
    Inc s -> pamixer' ["--unmute"] >> pamixer' ["--increase", T.pack .show $ s]
    Dec s -> pamixer' ["--decrease", T.pack . show $ s]
    Toggle -> pamixer' ["--toggle-mute"]


  vol <- getVolume
  liftIO $ putStrLn ("gotvolume" <> show vol)
  muted <- getMuted
  liftIO $ putStrLn ("gotmuted" <> show muted)
  let
    arg = if muted then "--mute" else T.pack . show $ vol
  liftIO $ putStrLn ("running volnoti-show with " <> T.unpack arg)
  void $ strict . inproc "volnoti-show" [arg] $ empty

