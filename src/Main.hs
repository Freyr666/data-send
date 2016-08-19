module Main where

import System.Environment(getArgs)
import Data.Aeson
import AtsData
import Stream
import Device
import Send
import Worker

main =
  let url     = "http://localhost:3000"
  in do
    workerFunction url 2000000 212123123123 5 1
