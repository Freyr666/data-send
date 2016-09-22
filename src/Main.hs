module Main where

import System.Environment(getArgs)
import Control.Monad
import Control.Concurrent.Async
import Data.Aeson
import AtsData
import Stream
import Device
import Send
import Worker

main =
  let url     = "http://192.168.111.88:3000"
      devs    = [1..6]
  in
    do
      res <- mapM (\dev -> do
                      thread <- async (workerFunction url 1 212123123123 30 dev)
                      return thread) devs
      mapM_ wait res
      print "Fin"
