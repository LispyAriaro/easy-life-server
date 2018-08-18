module Handlers.AccountHandler where

import Prelude

import Data.Either (Either(..))
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (error, Error, message)

import Database.Postgres (Pool, Query(Query), query_, withClient) as Pg
import Node.Express.Response (sendJson, setStatus)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)

import Rest as Rest
import Utils as Utils

signup :: Pg.Pool -> Handler
signup pool = do
  postBody <- getBody'
  let postBodyUser = (Utils.read' postBody) :: Either Error Rest.UserSignupSchema
  case postBodyUser of
    Left error -> liftEffect $ log $ "POSt payload parse error: " <> show error
    Right pBody -> liftEffect $ log $ show pBody

  sendJson {
    status: "All done!"
  }
