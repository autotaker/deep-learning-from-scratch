{-# LANGUAGE FlexibleContexts #-}
module RepaTest where

import Data.Array.Repa hiding (zipWith, (++))

-- [[1,2,3]
-- ,[4,5,6]]
xs :: Array U DIM2 Int
xs = fromListUnboxed (ix2 2 3) [1..6]

-- [1,4]
col0 = computeUnboxedS $ slice xs (Any :. (0 :: Int))
-- [2,5]
col1 = computeUnboxedS $ slice xs (Any :. (1 :: Int))
-- [3,6]
col2 = computeUnboxedS $ slice xs (Any :. (2 :: Int))

-- [1,2,3]
row0 = computeUnboxedS $ slice xs (Z :. (0::Int) :. All)
-- [4,5,6]
row1 = computeUnboxedS $ slice xs (Z :. (1::Int) :. All)

-- [[[1,1],[2,2],[3,3]]
-- ,[[4,4],[5,5],[6,6]]]
colextend2 = computeUnboxedS $ extend (Any :.(2::Int)) xs
-- [[[1,1,1],[2,2,2],[3,3,3]]
-- ,[[4,4,4],[5,5,5],[6,6,6]]]
colextend3 = computeUnboxedS $ extend (Any :.(3::Int)) xs

-- [[[1,2,3]
--  ,[1,2,3]]
-- ,[[4,5,6]
--  ,[4,5,6]]]
midextend2 = computeUnboxedS $ extend (Any :. (2::Int) :. All) xs
-- [[[1,2,3]
--  ,[1,2,3]
--  ,[1,2,3]]
-- ,[[4,5,6]
--  ,[4,5,6]
--  ,[4,5,6]]]
midextend3 = computeUnboxedS $ extend (Any :. (3::Int) :. All) xs

-- [[[1,2,3]
--  ,[4,5,6]]
-- ,[[1,2,3]
--  ,[4,5,6]]]
rowextend2 = computeUnboxedS $ extend (Z :. (2::Int) :. All :. All) xs
-- [[[1,2,3]
--  ,[4,5,6]]
-- ,[[1,2,3]
--  ,[4,5,6]]
-- ,[[1,2,3]
--  ,[4,5,6]]]
rowextend3 = computeUnboxedS $ extend (Z :. (3::Int) :. All :. All) xs

x1 :: Array U DIM1 Double
x1 = fromListUnboxed (ix1 3) [1..3]

x2 :: Array U DIM2 Double
x2 = fromListUnboxed (ix2 2 3) [1..6]

b1 :: Array U Z Double
b1 = fromListUnboxed Z [0.5]

b2 :: Array U DIM2 Double
b2 = fromListUnboxed (ix2 2 1) [10,100]

b3 :: Array U DIM2 Double
b3 = fromListUnboxed (ix2 1 3) [10,20,30]

-- x1 :: Z :. 3
-- b1 :: Z
x1b1 = computeUnboxedS $ x1 +^ extend (Any :. (3::Int)) b1

-- x2 :: Z :. 2 :. 3
-- b2 :: Z :. 2 :. 1
x2b2 = computeUnboxedS $ x2 +^ reshape (ix2 2 3) (extend (Any :. (3::Int)) b2)

-- x2 :: Z :. 2 :. 3
-- b3 :: Z :. 1 :. 3
x2b3 = computeUnboxedS $ x2 +^ reshape (ix2 2 3) (extend (Z :. (2::Int) :. All :. All) b3)

-- x2 :: Z :. 2 :. 3
-- b1 :: Z
x2b1 = computeUnboxedS $ x2 +^ extend (Any :. (2::Int) :. (3::Int)) b1

r1 :: Array U DIM1 Double
r1 = fromListUnboxed (ix1 3) [1..3]
c1 :: Array U DIM2 Double
c1 = fromListUnboxed (ix2 2 1) [10,20]
-- r1 :: Z :. 3
-- c1 :: Z :. 2 :. 1
r1c1 = computeUnboxedS $ (extend (Z :. (2::Int) :. All) r1) +^ (reshape (ix2 2 3) $ extend (Any :. (3::Int)) c1)

upShape1 :: DIM0 -> DIM1
upShape1 Z = ix1 1
upShape2 :: DIM1 -> DIM2
upShape2 (sh :. n) = upShape1 sh :. n
upShape3 :: DIM2 -> DIM3
upShape3 (sh :. n) = upShape2 sh :. n
upShape4 :: DIM3 -> DIM4
upShape4 (sh :. n) = upShape3 sh :. n
upShape5 :: DIM4 -> DIM5
upShape5 (sh :. n) = upShape4 sh :. n

shapeMod0 :: DIM0 -> DIM0 -> DIM0
shapeMod0 Z Z = Z
shapeMod1 :: DIM1 -> DIM1 -> DIM1
shapeMod1 (sh1 :. n) (sh2 :. m) = shapeMod0 sh1 sh2 :. (n `mod` m)
shapeMod2 :: DIM2 -> DIM2 -> DIM2
shapeMod2 (sh1 :. n) (sh2 :. m) = shapeMod1 sh1 sh2 :. (n `mod` m)
shapeMod3 :: DIM3 -> DIM3 -> DIM3
shapeMod3 (sh1 :. n) (sh2 :. m) = shapeMod2 sh1 sh2 :. (n `mod` m)
shapeMod4 :: DIM4 -> DIM4 -> DIM4
shapeMod4 (sh1 :. n) (sh2 :. m) = shapeMod3 sh1 sh2 :. (n `mod` m)
shapeMod5 :: DIM5 -> DIM5 -> DIM5
shapeMod5 (sh1 :. n) (sh2 :. m) = shapeMod4 sh1 sh2 :. (n `mod` m)
