module FFI.BCrypt (isPasswordCorrect, getPasswordHash) where

foreign import isPasswordCorrect :: String -> String -> Boolean

foreign import getPasswordHash :: String -> String