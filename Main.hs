module Main where

import Control.Concurrent (forkIO)
import Control.Monad.Reader
import qualified Data.ByteString.Char8 as BS
import Data.Ini
import Data.Text as T hiding (head)
import Data.Text.Encoding
import Data.Time
import Network.IRC.Client hiding (instanceConfig)
import Safe
import System.Exit
import System.Posix.Files
import Zn.Bot
import Zn.Commands
import Zn.Handlers
import Zn.Pinger

instanceConfig config = cfg { _eventHandlers = handlers ++ _eventHandlers cfg }
    where
        cfg = defaultIRCConf $ setting config "user"
        handlers =
            [ EventHandler "cmd handler" EPrivmsg cmdHandler]

connection :: Ini -> IO (ConnectionConfig BotState)
connection conf = (\conn -> conn { _onconnect = initHandler conf }) <$> action
    where
        action = connect' stdoutLogger host port 1
        host = (BS.pack . unpack $ setting conf "irchost")
        port = (maybe (error "cannot parse ircport") id . readMay . unpack $ setting conf "ircport")

main = do
    configFound <- fileExist "zn.rc"
    when (not configFound) $ do
        putStrLn "# no conf found\n$ cp zn.rc{sample,}"
        exitFailure

    conf <- either error id <$> readIniFile "zn.rc"
    state <- BotState <$> getCurrentTime <*> pure conf
    conn <- connection conf

    forkIO $ pinger conn (encodeUtf8 $ setting conf "user")
    startStateful conn (instanceConfig conf) state
