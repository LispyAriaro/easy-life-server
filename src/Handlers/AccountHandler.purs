module Handlers.AccountHandler where

import Prelude

import Data.Array ((!!), length)
import Data.Either (Either(..))
import Data.Foldable (for_)
import Database.Postgres (Pool, Query(Query), query_, execute_, withClient, connect, release, Client) as Pg
import Effect.Aff (launchAff_)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Exception (error, Error, message)
import FFI.UUID as UUID
import Foreign.Generic (encodeJSON)
import Models.User (User(..), getUserJwtPayload)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)
import Node.Express.Response (sendJson, setStatus)
import Query.Users as UsersQ
import Rest as Rest
import Utils as Utils


signup :: Pg.Pool -> Handler
signup dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserSignupSchema

  case decodedBody of
    Left error -> liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
    Right postBody -> do
      let sqlQuery = UsersQ.getBy "phone_number" postBody.phone_number

      usersWithPhone <- liftAff $ do
        conn <- Pg.connect dbPool
        queryResults <- Pg.query_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn
        liftEffect $ void $ for_ queryResults logShow
        liftEffect $ log ""
        liftEffect $ Pg.release conn
        pure queryResults
    
      if length usersWithPhone > 0 then do 
        setStatus 409
        sendJson {status: "failure", message: "A user with that phone number already exists."} 
        else do
          let sqlInsertQuery = UsersQ.insert UUID.new postBody.username postBody.phone_number postBody.password_hash
          liftEffect $ log $ "Insert query: " <> sqlInsertQuery

          userInsertResult <- liftAff $ do
            conn <- Pg.connect dbPool
            result <- liftAff $ Pg.execute_ (Pg.Query sqlInsertQuery :: Pg.Query Int) conn
            liftEffect $ log ""
              
            liftEffect $ Pg.release conn
            pure result

          sendJson {status: "success", message: "User signup was successful!", data: userInsertResult}
