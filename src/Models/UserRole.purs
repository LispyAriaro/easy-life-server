module Models.UserRole (UserRole(..)) where

import Prelude
import Data.Maybe (Maybe)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericDecode, genericEncode)

import Simple.JSON as JSON
import Utils as Utils


newtype UserRole = UserRole {
  id :: Int, 

  user_id :: Maybe Int, 
  role :: Maybe String
}

-- data Role = Consumer | ServiceProvider | Marketer | Administrator

-- instance showUserRole :: Show Role
--   where 
--     show (Role a) = show a

derive instance genericRole :: Generic UserRole _
derive newtype instance foreignJsonRole :: JSON.ReadForeign UserRole
instance showUserRole :: Show UserRole
  where show = genericShow

instance decodeUserRole :: Decode UserRole where
  decode = genericDecode Utils.jsonOpts

instance encodeUserRole :: Encode UserRole where
  encode = genericEncode Utils.jsonOpts
