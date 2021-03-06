{-# OPTIONS -Wall -Werror #-}

module Test.TestEaster where

import Data.Time.Calendar.Easter
import Data.Time.Calendar
import Data.Time.Format

import Test.TestUtil
import Test.TestEasterRef

--

days :: [Day]
days = [ModifiedJulianDay 53000 .. ModifiedJulianDay 53014]

showWithWDay :: Day -> String
showWithWDay = formatTime defaultTimeLocale "%F %A"

testEaster :: Test
testEaster = pureTest "testEaster" $ let 
    ds = unlines $ map (\day ->
                   unwords [ showWithWDay day, "->"
                           , showWithWDay (sundayAfter day)]) days

    f y = unwords [ show y ++ ", Gregorian: moon,"
                          , show (gregorianPaschalMoon y) ++ ": Easter,"
                          , showWithWDay (gregorianEaster y)]
                  ++ "\n"

    g y = unwords [ show y ++ ", Orthodox : moon,"
                          , show (orthodoxPaschalMoon y) ++ ": Easter,"
                          , showWithWDay (orthodoxEaster y)]
                  ++ "\n"

    in diff testEasterRef $ ds ++ concatMap (\y -> f y ++ g y) [2000..2020]
