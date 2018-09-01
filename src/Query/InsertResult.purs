module Query.InsertResult (InsertResult(InsertResult), InsertResultRow(InsertResultRow)) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericDecode, genericEncode)

import Simple.JSON as JSON
import Utils as Utils


newtype InsertResult = InsertResult {
  rowCount :: Int,
  rows :: Array InsertResultRow
}

derive instance genericInsertResult :: Generic InsertResult _
derive newtype instance foreignJsonInsertResult :: JSON.ReadForeign InsertResult 
instance showForeignInsertRow :: Show InsertResult
  where show = genericShow

instance decodeInsertResult :: Decode InsertResult where
  decode = genericDecode Utils.jsonOpts

instance encodeInsertResult :: Encode InsertResult where
  encode = genericEncode Utils.jsonOpts



newtype InsertResultRow = InsertResultRow {
  id :: Int
}

derive instance genericInsertResultRow :: Generic InsertResultRow _
derive newtype instance foreignJsonInsertResultRow :: JSON.ReadForeign InsertResultRow
instance showForeignInsertResultRow :: Show InsertResultRow
  where show = genericShow

instance decodeInsertResultRow :: Decode InsertResultRow where
  decode = genericDecode Utils.jsonOpts

instance encodeInsertResultRow :: Encode InsertResultRow where
  encode = genericEncode Utils.jsonOpts
