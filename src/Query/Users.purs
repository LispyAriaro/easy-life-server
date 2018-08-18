module Query.Users (getAll, insert) where

import Types

foreign import getAll :: String

foreign import insert :: UUID -> UserName -> PhoneNumber -> PasswordHash -> String
