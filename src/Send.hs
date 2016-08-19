module Send
  (
    sendMessage
  ) where

import Control.Lens
import Network.HTTP.Client ( HttpException(..) )
import Network.Wreq
import Control.Exception

catchHttp :: IO a -> (HttpException -> IO a) -> IO a
catchHttp = Control.Exception.catch

--dataSend :: String -> Postable a -> IO Int
dataSend url d = do
  r <- post url d
  let result = r ^. responseStatus . statusCode
      answer = r ^. responseStatus . statusMessage
    in
      return (result)

--sendMessage :: String -> Postable a -> Int
sendMessage url msg = 
  catchHttp (dataSend url msg) $ \e ->
                                   case e of
                                     (StatusCodeException s _ _) -> do
                                       let result = s ^. statusCode
                                         in return (result)
                                     _-> do
                                       putStrLn $ "Expn: " ++ show e
                                       return (-1)
