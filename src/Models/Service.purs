module Models.Service (Service(..)) where

import Prelude
import Data.Maybe (Maybe)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericDecode, genericEncode)

import Simple.JSON as JSON
import Utils as Utils

newtype Service = Service {
  id :: Int,
  uuid :: Maybe String,
  name :: Maybe String,
  description :: Maybe String,

  companyId :: Maybe String,
  serviceCategoryId :: Maybe String,
  price :: Maybe Number,

  isActive :: Maybe Boolean
}

derive instance genericService :: Generic Service _
derive newtype instance foreignJsonService :: JSON.ReadForeign Service
instance showForeignService :: Show Service
  where show = genericShow

instance decodeService :: Decode Service where
  decode = genericDecode Utils.jsonOpts

instance encodeService :: Encode Service where
  encode = genericEncode Utils.jsonOpts
