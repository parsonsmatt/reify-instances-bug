{-# language TemplateHaskell #-}

module Lib where

import Language.Haskell.TH.Syntax

discoverInstances :: Name -> Q Exp
discoverInstances name = do
    i <- reifyInstances name [VarT (mkName "a")]
    lift $ map show i

class C a where

instance C Int
instance C Double

mkTest :: Name -> Q Exp
mkTest clazz =
    [|
        do
            putStrLn $(lift $ show clazz)
            mapM_ (putStrLn . mappend "    ") $(discoverInstances clazz)
        |]

