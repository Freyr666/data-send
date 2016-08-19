{-# LANGUAGE OverloadedStrings #-}

module Worker
  (
    workerFunction
  )where

import Data.Int (Int64)
import System.Random
import Control.Concurrent
import Control.Monad
import Data.Aeson
import AtsData
import Stream
import Device
import Send
import Data.Time
import Data.Time.Clock.POSIX
import Data.Time.Format

dateFormat = "%FT%X"

secondsToDate :: Integer -> String
secondsToDate sec =
  let t = posixSecondsToUTCTime $ fromIntegral sec
  in formatTime defaultTimeLocale dateFormat t 

urlD     = "/var/devices/connect"
urlS     = "/var/streams/create"     
urlQ     = "/var/qos/upload"

sendStream :: String -> Int -> Int -> IO Int
sendStream url id dev =
  let astream = if (id `mod` 2) == 0
        then streamDefaultTS {sId = id, devSerial = dev}
        else streamDefaultIP {sId = id, devSerial = dev}
  in do
    resp <- sendMessage (url ++ urlS) (toJSON astream)
    return resp

sendQos :: String -> Int64 -> Int64 -> Int64 -> Int -> [Int] -> IO ()
sendQos url start_time end_time step serial ids =
  let half_hour = 60*30
  in if start_time >= end_time
     then putStrLn "Pack sent!"
     else
       do
         rvals <- mapM (\id ->
                          let pack  = Package {errCode = 0,
                                               errExt = 0,
                                               errorsCnt = 1,
                                               multiPid = False,
                                               pid = 0,
                                               priority = 1,
                                               param1 = 0,
                                               param2 = 0,
                                               time = start_time}
                              packs = packageLstGen (start_time + 1) (start_time + half_hour) step [pack] 
                              adata   = Ats {streamId = id, deviceSerial = serial,
                                             package = packs}
                          in do
                            resp <- sendMessage (url ++ urlQ) (toJSON adata)
                            return resp) ids
         --print $  "Time: " ++ (show start_time)
         --putStrLn (show rvals)
         threadDelay (10^2 * 1)
         sendQos url (start_time + half_hour) end_time step serial ids

sendData :: String -> Int64 -> Int64 -> Int64 -> Int -> IO ()
sendData url start_time end_time step serial =
  let streams = [1..20]
      ready = map (\id -> do
                      a <- sendStream url id serial
                      return a) streams
      result = foldM (\acc res -> do
                         a <- res
                         return (acc && (a == 200))) True ready
  in result >>= \result ->
    if not result
    then
      do
        threadDelay (10^6 * 30)
        sendData url start_time end_time step serial
    else
      sendQos url start_time end_time step serial streams

workerFunction :: String -> Int64 -> Int64 -> Int64 -> Int -> IO () 
workerFunction url start_time end_time step serial =
  let adev = deviceDefault {serial = serial}
  in do
    result <- sendMessage (url ++ urlD) (toJSON adev)
    if (result /= 200)
      then
      do
        threadDelay (10^6 * 30)
        workerFunction url start_time end_time step serial
      else
      sendData url start_time end_time step serial
