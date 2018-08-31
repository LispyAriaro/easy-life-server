module Rest (UserSignupSchema, UserLoginSchema, errorMessages) where

import Types

type UserSignupSchema = {
  username :: UserName,
  phone_number :: PhoneNumber,
  password :: String
}

type UserLoginSchema = {
  phone_number :: PhoneNumber,
  password :: String
}

errorMessages = {
  postBodyNotValid : "Post payload is not valid",
  userWithPhoneExists : "A user with that phone number already exists.",
  noJwtSecret: "Can't send token for next user requests"
}
