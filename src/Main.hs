module Main where

import System.Environment(getArgs)
import Control.Exception
import Control.Lens
import Data.Aeson
import Network.Wreq
import AtsData

catchAny :: IO a -> (SomeException -> IO a) -> IO a
catchAny = Control.Exception.catch

send url d = do
  r <- post url (toJSON d)
  let result = r ^. responseStatus . statusCode
    in return (result)

main =
  let adata   = Ats {streamId = 11, deviceSerial = 1,
                     package = [Package {errCode = 1,
                                         errExt = 1,
                                         errorsCnt = 1,
                                         multiPid = False,
                                         pid = 0,
                                         priority = 1,
                                         param1 = 0,
                                         param2 = 0,
                                         time = 12121475}]}
      url     = "http://localhost:3000/var/qos/upload"
  in do
    result <- catchAny (send url adata) $ \e -> do
                putStrLn $ "Expn: " ++ show e
                return (-1)
    print result
