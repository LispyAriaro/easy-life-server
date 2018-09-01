module Models.ServiceCategory (ServiceCategory(..)) where

import Prelude
import Data.Maybe (Maybe)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericDecode, genericEncode)

import Simple.JSON as JSON
import Utils as Utils

newtype ServiceCategory = ServiceCategory {
  id :: Int,
  uuid :: Maybe String,
  name :: Maybe String
}

derive instance genericServiceCategory :: Generic ServiceCategory _
derive newtype instance foreignJsonServiceCategory :: JSON.ReadForeign ServiceCategory
instance showForeignServiceCategory :: Show ServiceCategory
  where show = genericShow

instance decodeServiceCategory :: Decode ServiceCategory where
  decode = genericDecode Utils.jsonOpts

instance encodeServiceCategory :: Encode ServiceCategory where
  encode = genericEncode Utils.jsonOpts
