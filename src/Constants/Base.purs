module Constants.Base (jwtSecret, roles) where

jwtSecret = "JWT_SECRET"

roles = {
  consumer: "consumer",
  servieProvider: "serviceprovider",
  marketer: "marketer",
  administrator: "administrator"
}
