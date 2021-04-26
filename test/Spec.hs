{-# language TemplateHaskell #-}

module Main where

import Lib
import Language.Haskell.TH.Syntax

data X = X deriving Eq

-- class D a

instance C Char

main :: IO ()
main = do
    $(mkTest ''Eq)
    $(mkTest ''C)
    -- $(mkTest ''D)

