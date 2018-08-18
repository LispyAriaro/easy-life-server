module Handlers.AccountHandler where

import Prelude

import Data.Either (Either(..))
import Database.Postgres (Pool, Query(Query), query_, withClient, Client) as Pg
import Effect.Class (liftEffect)
import Effect.Aff.Class (liftAff)
import Data.Foldable (for_)

import Effect.Console (log, logShow)
import Effect.Exception (error, Error, message)
import Effect.Aff (launchAff_)

import Models.User (User(..), getUserJwtPayload)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)
import Node.Express.Response (sendJson, setStatus)

import Data.Array ((!!))

import Query.Users as UsersQ
import Rest as Rest
import Utils as Utils


signup :: Pg.Pool -> Pg.Client -> Handler
signup pool conn = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserSignupSchema

  case decodedBody of
    Left error -> liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
    Right postBody -> do
      liftEffect $ log $ "Phone : " <> postBody.phone_number

      -- let query = UsersQ.getBy "phone_number" postBody.phone_number
      let query = UsersQ.getAll
      liftEffect $ log $ "Db query: " <> query

      liftAff $ do
        usersWithPhone <- Pg.query_ Utils.readForeignJson (Pg.Query query :: Pg.Query User) conn
        liftEffect $ void $ for_ usersWithPhone logShow

        pure unit

      sendJson {
        status: "All done!"
      }
