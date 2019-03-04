{-# LANGUAGE FlexibleContexts #-}
module Neuron ( generate
              , generateP
              , tripleS
              , tripleP
              , forwardS
              , forwardP
              ) where

import Control.Monad
import Control.Monad.ST
import Data.List (foldl')

import qualified Data.Array.Repa as R
import Data.Array.Repa.Algorithms.Matrix

import Activation
import Util ((+#))

-- h is activation function
generateP (w1, w2, bias, h) x1 x2 = do
  s <- R.sumAllP (R.zipWith (*) x w)
  return $ h (bias + s)
  where
    x = R.fromListUnboxed (R.ix1 2) [x1, x2]
    w = R.fromListUnboxed (R.ix1 2) [w1, w2]

generate (w1, w2, bias, h) x1 x2 = h (bias + R.sumAllS (R.zipWith (*) x w))
  where
    x = R.fromListUnboxed (R.ix1 2) [x1, x2]
    w = R.fromListUnboxed (R.ix1 2) [w1, w2]
    

tripleP x (f, w, b) = do
  xw <- mmultP x w
  R.computeUnboxedP $ R.map f $ xw +# b

tripleS x (f, w, b) = R.computeUnboxedS $ R.map f $ mmultS x w +# b

forwardS :: (Foldable t, R.Source r Double) =>
  R.Array R.U R.DIM2 Double
  -> t (Double -> Double, R.Array R.U R.DIM2 Double, R.Array r R.DIM1 Double)
  -> R.Array R.U R.DIM2 Double
forwardS = foldl' tripleS

forwardP :: (Monad m, Foldable t, R.Source r Double) =>
  R.Array R.U R.DIM2 Double
  -> t (Double -> Double, R.Array R.U R.DIM2 Double, R.Array r R.DIM1 Double)
  -> m (R.Array R.U R.DIM2 Double)
forwardP = foldM tripleP
