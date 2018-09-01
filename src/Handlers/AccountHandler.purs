module Handlers.AccountHandler (signup, login, getMarketer) where

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


signup :: Pg.Pool -> Handler
signup dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserSignupSchema

  case decodedBody of
    Left error -> do
      liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
      sendJson {status: "failure", message: Rest.errorMessages.postBodyNotValid}
    Right postBody -> do
      case isSignupOk postBody of
        Left err -> do
          setStatus 409
          sendJson {status: "failure", message: err}
        Right _ -> do
          let phoneNumber = (PhoneNumber.getStandardNumber postBody.phoneNumber)
          let sqlQuery = Query.getBy TableNames.users TableColumns.users.phoneNumber phoneNumber

          maybeExistingUser <- liftAff $ do
            conn <- Pg.connect dbPool
            queryResults <- Pg.queryOne_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn
            liftEffect $ Pg.release conn
            pure queryResults

          case maybeExistingUser of
            Just _ -> do
              setStatus 409
              sendJson {status: "failure", message: Rest.errorMessages.userWithPhoneExists}
            Nothing -> do
              let newUuid = UUID.new
              let passHash = BCrypt.getPasswordHash postBody.password
              let insertRow = {uuid: newUuid, username: postBody.username, phone_number: phoneNumber, password_hash: passHash}
              let insertUserQ = Query.insert TableNames.users insertRow

              userInsertResult <- liftAff $ do
                conn <- Pg.connect dbPool
                result <- liftAff $ Query.executeWithResult Utils.readForeignJson (Pg.Query insertUserQ :: Pg.Query InsertResult) conn

                case Query.getInsertedId result of
                  Just insertedId -> do
                    let insertUserRoleQ = Query.insert TableNames.userRoles {user_id: insertedId, role: roles.consumer}
                    result2 <- liftAff $ Pg.execute_ (Pg.Query insertUserRoleQ :: Pg.Query InsertResult) conn

                    liftEffect $ Pg.release conn
                    pure result
                  Nothing -> pure result

              maybeJwtSecret <- liftEffect $ lookupEnv jwtSecret
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
                    status: "failure", message: Rest.errorMessages.noJwtSecret
                  }

login :: Pg.Pool -> Handler
login dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserLoginSchema

  case decodedBody of
    Left error -> do
      liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
      sendJson {status: "failure", message: Rest.errorMessages.postBodyNotValid}
    Right postBody -> do
      case isLoginOk postBody of
        Left err -> do
          setStatus 409
          sendJson {status: "failure", message: err}
        Right _ -> do
          let phoneNumber = (PhoneNumber.getStandardNumber postBody.phoneNumber)
          let sqlQuery = Query.getBy TableNames.users TableColumns.users.phoneNumber phoneNumber

          maybeExistingUser <- liftAff $ do
            conn <- Pg.connect dbPool
            queryResults <- Pg.queryOne_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn

            liftEffect $ for_ queryResults logShow
            liftEffect $ log ""
            liftEffect $ Pg.release conn
            pure queryResults

          case maybeExistingUser of
            Just user@(User { id, password_hash, uuid }) -> do
              if BCrypt.isPasswordCorrect postBody.password (fromMaybe "" password_hash) then do
                let sqlQuery2 = Query.getBy TableNames.userRoles TableColumns.userRoles.userId id

                userRoles <- liftAff $ do
                  conn <- Pg.connect dbPool
                  queryResults <- Pg.query_ Utils.readForeignJson (Pg.Query sqlQuery2 :: Pg.Query UserRole) conn
                  liftEffect $ for_ queryResults logShow
                  liftEffect $ log ""
                  liftEffect $ Pg.release conn
                  pure queryResults

                maybeJwtSecret <- liftEffect $ lookupEnv jwtSecret
                case maybeJwtSecret of
                  Just jwtSecret -> do
                    let jwtToken = Jwt.sign {uuid: uuid} jwtSecret
                    sendJson {
                      status: "success",
                      message: "User Login was successful!",
                      data: {uuid: uuid, token: jwtToken, roles: userRoles}
                    }
                  Nothing -> do
                    setStatus 500
                    sendJson {
                      status: "failure", message: Rest.errorMessages.noJwtSecret
                    }
                else do
                  setStatus 500
                  sendJson {
                    status: "failure", message: "Invalid username or password 3"
                  }
            Nothing -> do
              setStatus 500
              sendJson {
                status: "failure", message: "Invalid username or password 1"
              }

getMarketer :: Pg.Pool -> Handler
getMarketer dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.FindMarketer

  case decodedBody of
    Left error -> do
      liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
      sendJson {status: "failure", message: Rest.errorMessages.postBodyNotValid}
    Right postBody -> do
      case isFindMarketerOk postBody of
        Left err -> do
          setStatus 409
          sendJson {status: "failure", message: err}
        Right _ -> do
          let phoneNumber = (PhoneNumber.getStandardNumber postBody.phoneNumber)
          let sqlQuery = Query.getBy TableNames.users TableColumns.users.phoneNumber phoneNumber

          maybeExistingUser <- liftAff $ do
            conn <- Pg.connect dbPool
            queryResults <- Pg.queryOne_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn

            liftEffect $ for_ queryResults logShow
            liftEffect $ log ""
            liftEffect $ Pg.release conn
            pure queryResults

          case maybeExistingUser of
            Just user@(User { id, uuid }) -> do
              sendJson {
                status: "success",
                data: user
              }
            Nothing -> do
              sendJson {
                status: "failure",
                message: "No marketer uses that phone number!"
              }

-- type MyValidated a = V (NonEmptyList String) a


isSignupOk :: Rest.UserSignupSchema -> Either String Boolean
isSignupOk {username, phoneNumber, password} =
  if Str.length username < 1 then
    Left "Username was not specified"
    else
      if Str.length username < 1 then
        Left "Username was not specified"
        else
          if Str.length phoneNumber < 1 then
            Left "Phone Number was not specified"
            else
              if not $ PhoneNumber.isNgNumberOk phoneNumber then
                Left "Phone Number is not valid."
                else Right true

isLoginOk :: Rest.UserLoginSchema -> Either String Boolean
isLoginOk {phoneNumber, password} =
  if Str.length phoneNumber < 1 then
    Left "Phone Number was not specified"
    else
      if not $ PhoneNumber.isNgNumberOk phoneNumber then
        Left "Phone Number is not valid."
        else Right true

isFindMarketerOk :: Rest.FindMarketer -> Either String Boolean
isFindMarketerOk {phoneNumber} =
  if Str.length phoneNumber < 1 then
    Left "Phone number was not specified"
    else
      if not $ PhoneNumber.isNgNumberOk phoneNumber then
        Left "Phone Number is not valid."
        else Right true
