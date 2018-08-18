module FFI.Jwt (sign, signWithExpiry, verify) where

import Foreign (Foreign)

foreign import sign :: forall a. a -> String -> String

foreign import signWithExpiry :: forall a. a -> String -> String

foreign import verify :: String -> String -> Foreign
