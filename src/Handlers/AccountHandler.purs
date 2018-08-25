module Handlers.AccountHandler where

import Models.User
import Models.UserRole
import Prelude
import Query.InsertResult

import Constants (tableNames, userTableColumns, jwtSecret, roles)
import Data.Array (length, (!!))
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.CodeUnits as Str
import Database.Postgres (Pool, Query(Query), connect, execute, execute_, query_, queryOne_, queryValue_, withClient, release) as Pg
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Exception (error, Error, message)
import FFI.BCrypt as BCrypt
import FFI.Jwt as Jwt
import FFI.PhoneNumber as PhoneNumber
import FFI.UUID as UUID
import Foreign.Generic (encodeJSON)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getRouteParam, getQueryParam, getBody', getOriginalUrl, setUserData, getUserData)
import Node.Express.Response (sendJson, setStatus)
import Node.Process (lookupEnv)
import Query.Base as Query
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
          let sqlQuery = Query.getBy tableNames.users userTableColumns.phoneNumber phoneNumber

          maybeExistingUser <- liftAff $ do
            conn <- Pg.connect dbPool
            queryResults <- Pg.queryOne_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn
            liftEffect $ Pg.release conn
            pure queryResults
        
          case maybeExistingUser of
            Just _ -> do
              setStatus 409
              sendJson {status: "failure", message: "A user with that phone number already exists."} 
            Nothing -> do
              let newUuid = UUID.new
              let passHash = BCrypt.getPasswordHash postBody.password
              let insertUserQ = Query.insert tableNames.users {uuid: newUuid, username: postBody.username, phone_number: phoneNumber, password_hash: passHash}
              
              userInsertResult <- liftAff $ do
                conn <- Pg.connect dbPool
                result <- liftAff $ Query.executeWithResult Utils.readForeignJson (Pg.Query insertUserQ :: Pg.Query InsertResult) conn
                liftEffect $ log $ "insert resultty: \n" <> show result

                case Query.getInsertedId result of
                  Just insertedId -> do 
                    let insertUserRoleQ = Query.insert tableNames.userRoles {user_id: insertedId, role: roles.consumer}
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
                    status: "failure", message: "Can't send token for next user requests"
                  }

login :: Pg.Pool -> Handler
login dbPool = do
  foreignBody <- getBody'
  let decodedBody = (Utils.readForeignJson foreignBody) :: Either Error Rest.UserLoginSchema

  case decodedBody of
    Left error -> do
      liftEffect $ log $ "POST Body parse error: " <> show error <> "\n"
      sendJson {status: "failure", message: "Post payload is not valid"}
    Right postBody -> do
      case isLoginOk postBody of
        Left err -> do
          setStatus 409
          sendJson {status: "failure", message: err}
        Right _ -> do
          let phoneNumber = (PhoneNumber.getStandardNumber postBody.phone_number)
          let sqlQuery = Query.getBy tableNames.users userTableColumns.phoneNumber phoneNumber

          maybeExistingUser <- liftAff $ do
            conn <- Pg.connect dbPool
            -- queryResults <- Pg.query_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn
            queryResults <- Pg.queryOne_ Utils.readForeignJson (Pg.Query sqlQuery :: Pg.Query User) conn

            liftEffect $ for_ queryResults logShow
            liftEffect $ log ""
            liftEffect $ Pg.release conn
            pure queryResults
        
          case maybeExistingUser of
            Just user@(User { id, password_hash, uuid }) -> do
              if BCrypt.isPasswordCorrect postBody.password (fromMaybe "" password_hash) then do
                let sqlQuery2 = Query.getBy tableNames.userRoles "user_id" id

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
                      status: "failure", message: "Can't send token for next user requests"
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

isSignupOk :: Rest.UserSignupSchema -> Either String Boolean
isSignupOk {username, phone_number, password} = 
  if Str.length username < 1 then
    Left "Username was not specified"
    else
      if Str.length username < 1 then
        Left "Username was not specified"
        else    
          if Str.length phone_number < 1 then
            Left "Phone Number was not specified"
            else
              if not $ PhoneNumber.isNgNumberOk phone_number then
                Left "Phone Number is not valid."
                else Right true

isLoginOk :: Rest.UserLoginSchema -> Either String Boolean
isLoginOk {phone_number, password} = 
  if Str.length phone_number < 1 then
    Left "Phone Number was not specified"
    else
      if not $ PhoneNumber.isNgNumberOk phone_number then
        Left "Phone Number is not valid."
        else Right true
