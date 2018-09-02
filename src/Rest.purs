module Rest (
  UserSignupSchema, UserLoginSchema, FindMarketer,
  successStatus, failureStatus,
  errorMessages
) where

import Prelude
import Types

type UserSignupSchema = {
  username :: UserName,
  phoneNumber :: PhoneNumber,
  password :: String
}

type UserLoginSchema = {
  phoneNumber :: PhoneNumber,
  password :: String
}

type FindMarketer = {
  phoneNumber :: String
}

successStatus = "success"
failureStatus = "failure"

errorMessages = {
  postBodyNotValid : "Post payload is not valid",
  notSpecified : notSpecified,
  userWithPhoneExists : "A user with that phone number already exists.",
  noJwtSecret: "Can't send token for next user requests"
}

notSpecified :: String -> String
notSpecified fieldName = fieldName <> " is not specified"
