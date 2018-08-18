module Utils (readForeignJson, getDevDbConfig, getDbEnv, jsonOpts, logger, errorHandler) where

import Prelude

import Data.Bifunctor (lmap)
import Data.Either (Either)
import Data.Int (fromString)
import Data.Maybe (Maybe)
import Data.String.CodeUnits (drop)

import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Express.Response (sendJson, setStatus)
import Effect.Exception (error, Error, message)

import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)

import Foreign (Foreign)
import Foreign.Generic (defaultOptions)
import Foreign.Generic.Types (Options)
import Simple.JSON as JSON
import Types (DbConfig)


readForeignJson :: forall a. JSON.ReadForeign a => Foreign -> Either Error a
readForeignJson = lmap (error <<< show) <<< JSON.read

-- getDbConfig :: String -> Either String Pg.ClientConfig
getDevDbConfig :: String -> Either String DbConfig
getDevDbConfig s = lmap show (JSON.readJSON s)

getDbEnv :: Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe DbConfig
getDbEnv mDatabase mHost mPort mUser mPassword = 
  do 
    database <- mDatabase
    host <- mHost
    port <- mPort
    numPort <- fromString port
    user <- mUser
    password <- mPassword

    pure $ {
      database: database, host: host, port: numPort, 
      user: user, password: password, 
      ssl: false
    }

jsonOpts :: Options
jsonOpts = defaultOptions { unwrapSingleConstructors = true }

logger :: Handler
logger = do
  url   <- getOriginalUrl
  liftEffect $ log (">>> " <> url)
  setUserData "logged" url
  next

errorHandler :: Error -> Handler
errorHandler err = do
  setStatus 400
  sendJson {error: message err}
