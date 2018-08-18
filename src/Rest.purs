module Rest (UserSignupSchema) where

import Types

type UserSignupSchema = {
  username :: UserName, 
  phone_number :: PhoneNumber, 
  password_hash :: PasswordHash
}
