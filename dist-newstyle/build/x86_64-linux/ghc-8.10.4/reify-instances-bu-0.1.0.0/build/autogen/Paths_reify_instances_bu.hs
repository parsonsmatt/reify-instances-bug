{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_reify_instances_bu (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/matt/.cabal/bin"
libdir     = "/home/matt/.cabal/lib/x86_64-linux-ghc-8.10.4/reify-instances-bu-0.1.0.0-inplace"
dynlibdir  = "/home/matt/.cabal/lib/x86_64-linux-ghc-8.10.4"
datadir    = "/home/matt/.cabal/share/x86_64-linux-ghc-8.10.4/reify-instances-bu-0.1.0.0"
libexecdir = "/home/matt/.cabal/libexec/x86_64-linux-ghc-8.10.4/reify-instances-bu-0.1.0.0"
sysconfdir = "/home/matt/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "reify_instances_bu_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "reify_instances_bu_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "reify_instances_bu_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "reify_instances_bu_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "reify_instances_bu_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "reify_instances_bu_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
