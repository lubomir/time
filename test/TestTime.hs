{-# OPTIONS -Wall -Werror #-}

module Main where

import Data.Time.Clock
import Data.Time.Calendar

showCal :: Integer -> IO ()
showCal mjd = do
	let date = ModJulianDay mjd
	let (y,m,d) = gregorian date
	let date' = fromGregorian y m d
	putStr ((show mjd) ++ "=" ++ (showGregorian date))
	putStrLn (if date == date' then "" else "=" ++ (show (getModJulianDay date')) ++ "!")

testCal :: IO ()
testCal = do
	showCal 0	
	showCal 40000
	showCal 50000
	-- 1900 not a leap year
	showCal 15078
	showCal 15079
	-- 1980 is a leap year
	showCal 44297
	showCal 44298
	showCal 44299
	-- 1990 not a leap year
	showCal 47950
	showCal 47951
	-- 2000 is a leap year
	showCal 51602
	showCal 51603
	showCal 51604
	-- years 2000 and 2001, plus some slop
	mapM_ showCal [51540..52280]	

showUTCTime :: UTCTime -> String
showUTCTime (UTCTime d t) =  show (getModJulianDay d) ++ "," ++ show t

myzone :: Timezone
myzone = hoursToTimezone (- 8)

leapSec1998Cal :: DayAndTime
leapSec1998Cal = DayAndTime (fromGregorian 1998 12 31) (TimeOfDay 23 59 60.5)

leapSec1998 :: UTCTime
leapSec1998 = decodeLocalUTC utc leapSec1998Cal

testUTC :: IO ()
testUTC = do
	putStrLn ""
	showCal 51178
	putStrLn (show leapSec1998Cal)
	putStrLn (showUTCTime leapSec1998)
	let lsMineCal = encodeLocalUTC myzone leapSec1998
	putStrLn (show lsMineCal)
	let lsMine = decodeLocalUTC myzone lsMineCal
	putStrLn (showUTCTime lsMine)

neglong :: Rational
neglong = -120

poslong :: Rational
poslong = 120

testUT1 :: IO ()
testUT1 = do
	putStrLn ""
	putStrLn (show (encodeLocalUT1 0 (ModJulianDate 51604.0)))
	putStrLn (show (encodeLocalUT1 0 (ModJulianDate 51604.5)))
	putStrLn (show (encodeLocalUT1 neglong (ModJulianDate 51604.0)))
	putStrLn (show (encodeLocalUT1 neglong (ModJulianDate 51604.5)))
	putStrLn (show (encodeLocalUT1 poslong (ModJulianDate 51604.0)))
	putStrLn (show (encodeLocalUT1 poslong (ModJulianDate 51604.5)))

main :: IO ()
main = do
	testCal
	testUTC
	testUT1
