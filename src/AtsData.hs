module AtsData
  (
    Ats (..),
    Package (..),
    packageDefault,
    atsDefault,
    atsAppendPackage
  ) where

import Data.Int (Int64)

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
  } deriving (Eq)
  
data Ats = Ats {
  streamId     :: Int,
  deviceSerial :: Int,
  package      :: [Package]
  } deriving (Eq)

instance Show Package where
  show d =
    let isMulty p = if p then "true" else "false"
    in "{\"err_code\":"   ++ show (errCode d)     ++ "," ++
       "\"err_ext\":"     ++ show (errExt d)      ++ "," ++
       "\"errors_cnt\":"  ++ show (errorsCnt d)   ++ "," ++
       "\"multipid\":"    ++ isMulty (multiPid d) ++ "," ++
       "\"pid\":"         ++ show (pid d)         ++ "," ++
       "\"priority\":"    ++ show (priority d)    ++ "," ++
       "\"param_1\":"     ++ show (param1 d)      ++ "," ++
       "\"param_2\":"     ++ show (param2 d)      ++ "," ++
       "\"time\":"        ++ show (time d)        ++ "}"

instance Show Ats where
  show d =
    let pacToVec p =
          case p of
            []      -> ""
            [h]     -> show h
            (h:tl)  -> show h ++ "," ++ pacToVec tl
    in ("{\"stream_id\":"     ++ show (streamId d)     ++ "," ++
        "\"dev_serial\":"     ++ show (deviceSerial d) ++ "," ++
        "\"package\":" ++ "[" ++ pacToVec (package d)  ++ "]}")

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

atsDefault :: Ats
atsDefault = Ats {streamId = 1,
                  deviceSerial = 1,
                  package = [packageDefault]}

atsAppendPackage :: Ats -> Package -> Ats
atsAppendPackage ats_data pack =
  ats_data { package = pack : package ats_data}

