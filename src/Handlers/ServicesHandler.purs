module Handlers.ServicesHandler (updateServiceDetails) where

import Constants.Base (jwtSecret, roles)
import Constants.TableColumns as TableColumns
import Constants.TableNames as TableNames
import Data.Either (Either(..))
import Data.Foldable (for_)
-- import Data.List.Types (NonEmptyList(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.CodeUnits as Str
import Database.Postgres (Pool, Query(Query), connect, execute_, queryOne_, query_, release) as Pg
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Exception (Error)
import FFI.BCrypt as BCrypt
import FFI.Jwt as Jwt
import FFI.PhoneNumber as PhoneNumber
import FFI.UUID as UUID
import Models.User (User(User))
import Models.UserRole (UserRole)
import Node.Express.Handler (Handler)
import Node.Express.Request (getBody')
import Node.Express.Response (sendJson, setStatus)
import Node.Process (lookupEnv)
import Prelude (bind, discard, not, pure, show, ($), (<), (<>))
import Query.Base as Query
import Query.InsertResult (InsertResult)
import Rest as Rest
import Utils as Utils


updateServiceDetails :: Pg.Pool -> Handler
updateServiceDetails dbPool = do
  foreignBody <- getBody'

  setStatus 500
  sendJson {
    status: "failure", message: Rest.errorMessages.noJwtSecret
  }
