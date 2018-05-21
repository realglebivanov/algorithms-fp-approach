module Exercises.FiveFive.Set(
  Set,
  fromList,
  emptySet,
  setEmpty,
  add,
  inSet,
  included,
  inter,
  union
) where

newtype Set a = St [a] deriving (Show)

fromList :: (Ord a) => [a] -> Set a
fromList = foldr (\num set -> add num set) (emptySet)

emptySet :: (Ord a) => Set a
emptySet = St []

setEmpty :: (Ord a) => Set a -> Bool
setEmpty (St []) = True
setEmpty _ = False

add :: (Ord a) => a -> Set a -> Set a
add y (St xs) = St (insert xs)
  where
    insert [] = [y]
    insert xss@(x:xs)
      | x >= y = y:xss
      | x < y = x:(insert xs)

inSet :: (Ord a) => Set a -> a -> Bool
inSet (St xs) y = search xs
  where
    search [] = False
    search (x:xs)
      | x == y = True
      | x > y = False
      | otherwise = search xs

included :: (Ord a) => Set a -> Set a -> Bool
included (St []) _ = True
included _ (St []) = True
included (St xs) other = all (inSet other) xs

inter :: (Ord a) => Set a -> Set a -> Set a
inter first@(St []) _ = first
inter _ second@(St []) = second
inter (St xs) other = St $ filter (inSet other) xs

union :: (Ord a) => Set a -> Set a -> Set a
union (St []) other = other
union first (St []) = first
union (St xs) second@(St ys)
  | firstX > firstY = St $ (takeWhile (< firstX) ys) ++ xs
  | firstX < firstY = St $ (takeWhile (< firstY) xs) ++ ys
  | otherwise = foldr (\x set -> add x set) second xs
    where
      firstX = xs !! 0
      firstY = ys !! 0
