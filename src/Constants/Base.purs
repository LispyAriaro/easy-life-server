module Constants.Base (
  jwtSecret, 
  roles, 
  serviceGroupDefaultName
) where


jwtSecret = "JWT_SECRET"

roles = {
  consumer: "consumer",
  servieProvider: "serviceprovider",
  marketer: "marketer",
  administrator: "administrator"
}

serviceGroupDefaultName = "Default"
