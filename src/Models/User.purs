module Models.User (User(..)) where

import Prelude
import Data.Maybe (Maybe)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericDecode, genericEncode)

import Simple.JSON as JSON
import Utils as Utils


newtype User = User {
  id :: Int,
  uuid :: Maybe String,

  first_name :: Maybe String,
  last_name :: Maybe String,
  username :: Maybe String,
  password_hash :: Maybe String,

  email_address :: Maybe String,
  phone_number :: Maybe String,

  is_email_address_verified :: Maybe Boolean,
  is_phone_number_verified :: Maybe Boolean,

  image_url :: Maybe String,
  cloudinary_image_public_id :: Maybe String,
  
  created_by :: Maybe String,

  is_active :: Maybe Boolean
}

derive instance genericUser :: Generic User _
derive newtype instance foreignJsonUser :: JSON.ReadForeign User
instance showForeignUser :: Show User
  where show = genericShow

instance decodeUser :: Decode User where
  decode = genericDecode Utils.jsonOpts

instance encodeUser :: Encode User where
  encode = genericEncode Utils.jsonOpts
