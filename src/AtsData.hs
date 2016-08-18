{-# LANGUAGE OverloadedStrings #-}

module AtsData
  (
    Ats (..),
    Package (..),
    packageDefault,
    atsDefault,
    atsAppendPackage
  ) where

import Data.Int (Int64)
import Data.Aeson
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)

data Package = Package {
  errCode      :: Int,
  errExt       :: Int,
  errorsCnt    :: Int,
  multiPid     :: Bool,
  pid          :: Int,
  priority     :: Int,
  param1       :: Int,
  param2       :: Int,
  time         :: Int64
  } deriving (Eq,Show)

instance FromJSON Package where
  parseJSON (Object v) = Package
                         <$> v .: "err_code"
                         <*> v .: "err_ext"
                         <*> v .: "errors_cnt"
                         <*> v .: "multipid"
                         <*> v .: "pid"
                         <*> v .: "priority"
                         <*> v .: "param_1"
                         <*> v .: "param_2"
                         <*> v .: "time"
  parseJSON _ = mzero

instance ToJSON Package where
  toJSON (Package errCode errExt errorsCnt multiPid pid priority param1 param2 time) =
    object ["err_code"   .= errCode,
            "err_ext"    .= errExt,
            "errors_cnt" .= errorsCnt,
            "multipid"   .= multiPid,
            "pid"        .= pid,
            "priority"   .= priority,
            "param_1"    .= param1,
            "param_2"    .= param2,
            "time"       .= time]
           
packageDefault :: Package
packageDefault = Package {errCode = 0,
                          errExt = 0,
                          errorsCnt = 1,
                          multiPid = False,
                          pid = 0,
                          priority = 1,
                          param1 = 0,
                          param2 = 0,
                          time = 0}
  
data Ats = Ats {
  streamId     :: Int,
  deviceSerial :: Int,
  package      :: [Package]
  } deriving (Eq,Show)

instance FromJSON Ats where
  parseJSON (Object v) = Ats
                         <$> v .: "stream_id"
                         <*> v .: "dev_serial"
                         <*> v .: "package"
  parseJSON _ = mzero

instance ToJSON Ats where
  toJSON (Ats streamId deviceSerial package) =
    object ["stream_id"  .= streamId,
            "dev_serial" .= deviceSerial,
            "package"    .= package]

atsDefault :: Ats
atsDefault = Ats {streamId = 1,
                  deviceSerial = 1,
                  package = [packageDefault]}

atsAppendPackage :: Ats -> Package -> Ats
atsAppendPackage ats_data pack =
  ats_data { package = pack : package ats_data}

