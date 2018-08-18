module FFI.PhoneNumber (isNgNumberOk, getStandardNumber) where

foreign import isNgNumberOk :: forall a. String -> Boolean

foreign import getStandardNumber :: forall a. String -> String
