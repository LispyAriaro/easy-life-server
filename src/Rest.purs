module Rest (UserSignupSchema, UserLoginSchema, FindMarketer, errorMessages) where

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

errorMessages = {
  postBodyNotValid : "Post payload is not valid",
  userWithPhoneExists : "A user with that phone number already exists.",
  noJwtSecret: "Can't send token for next user requests"
}
