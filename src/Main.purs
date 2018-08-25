module Main where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Database.Postgres (Pool, connectionInfoFromConfig, defaultPoolConfig, mkPool) as Pg
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Handlers.AccountHandler as AccountHandler
import Middleware.BodyParser (jsonBodyParser)
import Middleware.Helmet (helmet)
import Node.Encoding (Encoding(..))
import Node.Express.App (App, listenHttp, post, setProp, use, useExternal, useOnError)
import Node.FS.Aff (readTextFile)
import Node.Process (lookupEnv)

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
    dbPort <- lookupEnv "port"

    case (Utils.getDbEnv database host dbPort user password) of 
      Just prodDbConfig -> startServer prodDbConfig
      Nothing -> 
        case Utils.getDevDbConfig contents of
          Left error -> log error
          Right devDbConfig -> startServer devDbConfig

startServer :: DbConfig -> Effect Unit
startServer dbConfig = do
  dbPool <- Pg.mkPool $ Pg.connectionInfoFromConfig dbConfig Pg.defaultPoolConfig

  void $ listenHttp (appSetup dbPool) 8080 \_ -> log "Server listening on port 8080.\n"

appSetup :: Pg.Pool -> App
appSetup dbPool = do
  useExternal helmet
  useExternal jsonBodyParser

  liftEffect $ log "Setting up"
  setProp "json spaces" 4.0
  use                                 (Utils.logger)

  post "/api/v1/usersignup"           (AccountHandler.signup dbPool)
  post "/api/v1/userlogin"            (AccountHandler.login dbPool)

  useOnError                          (Utils.errorHandler)
