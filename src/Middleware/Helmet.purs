module Middleware.Helmet (helmet) where

import Prelude

import Effect (Effect)
import Data.Function.Uncurried (Fn3)
import Node.Express.Types (Response, Request)

foreign import helmet :: Fn3 Request Response (Effect Unit) (Effect Unit)
