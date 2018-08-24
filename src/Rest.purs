module Rest (UserSignupSchema, UserLoginSchema) where

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
