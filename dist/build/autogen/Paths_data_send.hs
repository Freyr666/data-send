module Paths_data_send (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/freyr/.cabal/bin"
libdir     = "/home/freyr/.cabal/lib/x86_64-linux-ghc-7.8.4/data-send-0.1.0.0"
datadir    = "/home/freyr/.cabal/share/x86_64-linux-ghc-7.8.4/data-send-0.1.0.0"
libexecdir = "/home/freyr/.cabal/libexec"
sysconfdir = "/home/freyr/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "data_send_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "data_send_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "data_send_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "data_send_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "data_send_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
