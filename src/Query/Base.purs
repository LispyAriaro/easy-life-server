module Query.Base (getAll, getBy, insert, executeWithResult, getInsertedId) where

import Prelude

import Data.Array (last)
import Data.Either (Either, either)
import Data.Maybe (Maybe(Nothing, Just))
import Database.Postgres (Query(Query), Client)
import Effect.Aff (Aff, throwError)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Exception (Error)
import Foreign (Foreign)
import Query.InsertResult (InsertResult(..), InsertResultRow(..))

foreign import getAll :: String -> String

foreign import getBy :: forall a. String -> String -> a -> String

foreign import insert :: forall a. a -> String -> String

foreign import runInsertQuery_ :: String -> Client -> EffectFnAff Foreign

executeWithResult :: forall a. (Foreign → Either Error a) -> Query a -> Client -> Aff (Maybe a)
executeWithResult decode (Query sql) client = do
  val <- fromEffectFnAff $ runInsertQuery_ sql client
  either throwError (pure <<< Just) $ (decode val)


getInsertedId :: Maybe InsertResult -> Maybe Int
getInsertedId maybeInsertResult =
  case maybeInsertResult of
    Nothing -> Nothing
    Just insertResult@(InsertResult{rowCount, rows}) -> do
      if rowCount > 0 then do
        let lastInsertRow = last rows
        case lastInsertRow of
          Just mii@(InsertResultRow{id}) -> Just id
          Nothing -> Nothing
        else Nothing
