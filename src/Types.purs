module Types (DbConfig, UUID, UserName, PhoneNumber, PasswordHash) where

type DbConfig = 
  { database :: String
  , host :: String
  , port :: Int
  , user :: String
  , password :: String
  , ssl :: Boolean
  }

type UUID = String
type UserName = String
type PhoneNumber = String
type PasswordHash = String
