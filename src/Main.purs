module Main where

import Prelude
import Prelude hiding (apply)

import Data.Array as A
import Data.Either (Either(..))
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Database.Postgres (connectionInfoFromConfig, defaultPoolConfig, mkPool, Pool) as Pg
import Effect (Effect)
import Effect (Effect)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Console (log)
import Effect.Console (log)
import Effect.Exception (Error, error, message)
import Effect.Ref (Ref, modify', read, new)
import Foreign (ForeignError(..))
import Foreign.Generic (encodeJSON)
import Handlers.AccountHandler as AccountHandler
import Middleware.BodyParser (jsonBodyParser)
import Models.User (User(..), getUserJwtPayload)
import Node.Encoding (Encoding(..))
import Node.Express.App (App, listenHttp, useOnError, get, post, use, setProp, useExternal)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody, getBody', getOriginalUrl, setUserData, getUserData)
import Node.Express.Response (sendJson, setStatus)
import Node.FS.Aff (readTextFile)
import Node.HTTP (Server)
import Node.HTTP (createServer, listen)
import Node.Process (lookupEnv)
import Node.Process (lookupEnv)
import Rest as Rest
import Types (DbConfig)
import Utils as Utils


main :: Effect Unit
main = launchAff_ $ do 
  contents <- readTextFile UTF8 "./config/dbDev.json"
  
  liftEffect $ do
    database <- lookupEnv "database"
    host <- lookupEnv "host"
    user <- lookupEnv "user"
    password <- lookupEnv "password"
    port <- lookupEnv "port"

    case (Utils.getDbEnv database host port user password) of 
      Just prodDbConfig -> startServer prodDbConfig
      Nothing -> 
        case Utils.getDevDbConfig contents of
          Left error -> log error
          Right devDbConfig -> startServer devDbConfig

startServer :: DbConfig -> Effect Unit
startServer dbConfig = do
  dbPool <- Pg.mkPool $ Pg.connectionInfoFromConfig dbConfig Pg.defaultPoolConfig
  
  _ <- listenHttp (appSetup dbPool) 8080 \_ -> log "Server listening on port 8080.\n"
  
  pure unit

appSetup :: Pg.Pool -> App
appSetup dbPool = do
  useExternal jsonBodyParser

  liftEffect $ log "Setting up"
  setProp "json spaces" 4.0
  use                                 (Utils.logger)

  post "/api/v1/usersignup"           (AccountHandler.signup dbPool)

  useOnError                          (Utils.errorHandler)
