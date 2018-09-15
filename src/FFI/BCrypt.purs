module FFI.BCrypt (isPasswordCorrect, hashIt) where

foreign import isPasswordCorrect :: String -> String -> Boolean

foreign import hashIt :: String -> String
