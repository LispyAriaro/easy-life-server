module Query.Users (getAll, getBy, insert) where

import Types

foreign import getAll :: String

foreign import getBy :: String -> String -> String

foreign import insert :: UUID -> UserName -> PhoneNumber -> PasswordHash -> String
