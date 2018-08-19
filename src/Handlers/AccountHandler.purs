module Handlers.AccountHandler where

import Prelude

import Data.Array (length)
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Database.Postgres (Pool, Query(Query), connect, execute_, query_, release) as Pg
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Exception (error, Error, message)
import FFI.BCrypt as BCrypt
import FFI.Jwt as Jwt
import FFI.PhoneNumber as PhoneNumber
import FFI.UUID as UUID
import Foreign.Generic (encodeJSON)
import Models.User (User)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)
import Node.Express.Response (sendJson, setStatus)
import Node.Process (lookupEnv)
import Query.Users as UsersQ
import Rest as Rest
import Utils as Utils


signup :: Pg.Pool -> Handler
signup dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserSignupSchema

  case decodedBody of
    Left error -> do
      liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
      sendJson {status: "failure", message: "Post payload is not valid"}
    Right postBody -> do
      case isSignupOk postBody of
        Left err -> do
          setStatus 409
          sendJson {status: "failure", message: err}
        Right _ -> do
          let phoneNumber = (PhoneNumber.getStandardNumber postBody.phone_number)
          let sqlQuery = UsersQ.getBy "phone_number" phoneNumber

          usersWithPhone <- liftAff $ do
            conn <- Pg.connect dbPool
            queryResults <- Pg.query_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn
            liftEffect $ for_ queryResults logShow
            liftEffect $ log ""
            liftEffect $ Pg.release conn
            pure queryResults
        
          if length usersWithPhone > 0 then do
            setStatus 409
            sendJson {status: "failure", message: "A user with that phone number already exists."} 
            else do
              let newUuid = UUID.new
              let passHash = BCrypt.getPasswordHash postBody.password
              let sqlInsertQuery = UsersQ.insert newUuid postBody.username phoneNumber passHash

              userInsertResult <- liftAff $ do
                conn <- Pg.connect dbPool
                result <- liftAff $ Pg.execute_ (Pg.Query sqlInsertQuery :: Pg.Query Int) conn
                liftEffect $ log ""

                liftEffect $ Pg.release conn
                pure result
              
              maybeJwtSecret <- liftEffect $ lookupEnv "JWT_SECRET"
              case maybeJwtSecret of
                Just jwtSecret -> do
                  let jwtToken = Jwt.sign {uuid: newUuid} jwtSecret
                  sendJson {
                    status: "success", 
                    message: "User signup was successful!", 
                    data: {uuid: newUuid, token: jwtToken}
                  }
                _ -> do
                  setStatus 500
                  sendJson {
                    status: "failure", message: "Can't send token for next user requests"
                  }

isSignupOk :: Rest.UserSignupSchema -> Either String Boolean
isSignupOk {username, phone_number, password} = 
  if not $ PhoneNumber.isNgNumberOk phone_number then
    Left "Phone Number is not valid."
    else Right true



-- login :: Pg.Pool -> Handler
-- login dbPool = do
--   foreignBody <- getBody'
--   let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserLoginSchema

--   case decodedBody of
