module Rest (UserSignupSchema) where

import Types

type UserSignupSchema = {
  username :: UserName, 
  phone_number :: PhoneNumber, 
  password :: String
}

type UserLoginSchema = {
  username :: UserName, 
  phone_number :: PhoneNumber, 
  password :: String
}
