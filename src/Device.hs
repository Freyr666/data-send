{-# LANGUAGE OverloadedStrings #-}

module Device where

import Data.Aeson
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)

data DeviceType = DTC | ATP | ATS

devTypeToInt :: DeviceType -> Int
devTypeToInt DTC = 1
devTypeToInt ATP = 2
devTypeToInt ATS = 3

data Device = Device {
  serial    :: Int,
  devType  :: Int,
  devName  :: String
  } deriving (Eq,Show)

instance FromJSON Device where
  parseJSON (Object v) = Device
                         <$> v .: "serial"
                         <*> v .: "type"
                         <*> v .: "name"
  parseJSON _ = mzero

instance ToJSON Device where
  toJSON (Device serial devType devName) =
    object ["serial"  .= serial,
             "type"    .= devType,
             "name"    .= devName]

deviceDefault :: Device
deviceDefault = Device {
  serial  = 1,
  devType = 3,
  devName = "test_device"
  }
