# reify-instances-bug

While trying to use `reifyInstances`, I ran into some weird behavior.

## GHC internal error

```haskell
module Lib where

import Language.Haskell.TH.Syntax

discoverInstances :: Name -> Q Exp
discoverInstances name = do
    i <- reifyInstances name [VarT (mkName "a")]
    lift $ map show i
```

This should just grab all the instances of the type class in scope, `show` the `Dec`, and then splice it in as a list of strings.

It works just fine with `''Eq`, but with a class defined in the same module, it fails:

```haskell
{-# language TemplateHaskell #-}

import Lib

class C a

instance C Int
instance C Double

say = mapM_ putStrLn

main :: IO ()
main = do
    say $(discoverInstances ''Eq)
    say $(discoverInstances ''C)

```

gives the GHC output:

```
reify-instances-bu-0.1.0.0: unregistering (local file changes: .stack-work/dist/x86_64-linux-tinfo6/Cabal-3.2.1.0/build/reify-instances-bu-test/autogen/Paths_re...)
reify-instances-bu> configure (lib + test)
Configuring reify-instances-bu-0.1.0.0...
reify-instances-bu> build (lib + test)
Preprocessing library for reify-instances-bu-0.1.0.0..
Building library for reify-instances-bu-0.1.0.0..
Preprocessing test suite 'reify-instances-bu-test' for reify-instances-bu-0.1.0.0..
Building test suite 'reify-instances-bu-test' for reify-instances-bu-0.1.0.0..
[2 of 2] Compiling Main
            
/home/matt/Projects/reify-instances-bu/test/Spec.hs:15:11: error:
    • GHC internal error: ‘C’ is not in scope during type checking, but it passed the renamer
      tcl_env of environment: [a3mJ :-> Type variable ‘a’ = a :: k0]
    • In the type ‘C a’
      In the argument of reifyInstances: Main.C a
      In the untyped splice: $(discoverInstances ''C)
   |        
15 |     say $(discoverInstances ''C)
   |           ^^^^^^^^^^^^^^^^^^^^^
            
Progress 1/2
```

## No instances defined in same module

If I move the definition of `C` to a different module but keep the instances defined in the same module, it doesn't work.

```haskell
module Lib where

import Language.Haskell.TH.Syntax

discoverInstances :: Name -> Q Exp
discoverInstances name = do
    i <- reifyInstances name [VarT (mkName "a")]
    lift $ map show i

class C a where

{-# language TemplateHaskell #-}

module Main where

import Lib

instance C Int
instance C Double

say msg xs = putStrLn msg >> mapM_ putStrLn xs

main :: IO ()
main = do
    say "Eq" $(discoverInstances ''Eq)
    say "C" $(discoverInstances ''C)
```

Now, the code fails to print anything for `''C` call.


```
-- snipp.... from the ''Eq call
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT Language.Haskell.TH.Syntax.TySynEqn)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT Language.Haskell.TH.Syntax.TyVarBndr)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT Language.Haskell.TH.Syntax.Type)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT Language.Haskell.TH.Syntax.TypeFamilyHead)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT GHC.Integer.Type.BigNat)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT GHC.Integer.Type.Integer)) []
InstanceD Nothing [] (AppT (ConT GHC.Classes.Eq) (ConT GHC.Natural.Natural)) []
C
                         
```

Note the empty list there. What gives?

## Instances defined in other module

These work just fine.
