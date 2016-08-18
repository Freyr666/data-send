module Main where

import System.Environment(getArgs)
import Network.HTTP
import AtsData

main =
  let adata   = show atsDefault {streamId = 11}
      url     = "http://localhost:3000/var/qos/upload"
      req     = postRequestWithBody url "application/json" adata
  in do resp    <- simpleHTTP req
        str     <- fmap (take 100) (getResponseBody resp)
        putStrLn str
