module Constants.TableColumns (
  users, userRoles
) where

users = {
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

userRoles = {
  id: "id", 
  userId: "user_id",
  role: "role"
}
