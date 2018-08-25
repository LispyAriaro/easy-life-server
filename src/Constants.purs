module Constants (
  tableNames, userTableColumns, jwtSecret, roles
) where


jwtSecret = "JWT_SECRET"


tableNames :: { users :: String, userRoles :: String}
tableNames = {
  users: "users",
  userRoles: "user_roles"
}

userTableColumns :: { id :: String
    , uuid :: String
    , username :: String
    , passwordHash :: String
    , emailAddress :: String
    , phoneNumber :: String
    , isEmailAddressVerified :: String
    , isPhoneNumbeVerified :: String
    , imageUrl :: String
    , cloudinaryImagePublicId :: String
    , isEnabled :: String
    }
userTableColumns = {
  id: "id", 
  uuid: "uuid",
  username: "username",
  passwordHash: "password_hash",

  emailAddress: "email_address",
  phoneNumber: "phone_number",

  isEmailAddressVerified: "is_email_address_verified", 
  isPhoneNumbeVerified: "is_phone_number_verified", 

  imageUrl: "image_url",
  cloudinaryImagePublicId: "cloudinary_image_public_id",

  isEnabled: "is_enabled"
}

roles :: { consumer :: String, servieProvider :: String, marketer :: String, administrator :: String}
roles = {
  consumer: "consumer",
  servieProvider: "serviceprovider",
  marketer: "marketer",
  administrator: "administrator"
}
