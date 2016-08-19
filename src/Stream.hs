{-# LANGUAGE OverloadedStrings #-}

module Stream where

import Data.Aeson
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)

inputs = ["ASI1", "ASI2", "ASI3", "RF", "IP1", "IP2"]

data Stream = Stream {
  sId           ::  Int,
  devSerial     ::  Int,
  name          ::  String,
  input         ::  String,
  inputName     ::  String,
  typeT2mi      ::  Bool,
  parentId      ::  Int,
  freqPort      ::  Int,
  addsStand     ::  String,
  plp           ::  Int
  } deriving (Eq,Show)

instance FromJSON Stream where
  parseJSON (Object v) = Stream
                         <$> v .: "stream_id"
                         <*> v .: "dev_serial"
                         <*> v .: "name"
                         <*> v .: "input"
                         <*> v .: "input_name"
                         <*> v .: "type_t2mi"
                         <*> v .: "parent_id"
                         <*> v .: "freq_port"
                         <*> v .: "adds_stand"
                         <*> v .: "plp"
  parseJSON _ = mzero

instance ToJSON Stream where
  toJSON (Stream sId devSerial
          name input inputName typeT2mi
          parentId freqPort addsStand plp) =
    object ["stream_id"  .= sId,
            "dev_serial" .= devSerial,
            "name"       .= name,
            "input"      .= input,
            "input_name" .= inputName,
            "type_t2mi"  .= typeT2mi,
            "parent_id"  .= parentId,
            "freq_port"  .= freqPort,
            "adds_stand" .= addsStand,
            "plp"        .= plp]

streamDefaultTS :: Stream
streamDefaultTS = Stream {
  sId          = 1,
  devSerial    = 1,
  name         = "test",
  input        = "ASI1",
  inputName    = "test_in",
  typeT2mi     = False,
  parentId     = 0,
  freqPort     = 666,
  addsStand    = "TS",
  plp          = 1
  }

streamDefaultIP :: Stream
streamDefaultIP = Stream {
  sId          = 1,
  devSerial    = 1,
  name         = "test",
  input        = "IP1",
  inputName    = "test_in",
  typeT2mi     = False,
  parentId     = 0,
  freqPort     = 1234,
  addsStand    = "224.1.2.2",
  plp          = 1
  }
