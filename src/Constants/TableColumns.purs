module Constants.TableColumns (
  users, userRoles, 
  serviceGroups, services, serviceImages, serviceProviderCompanies, 
  locations
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

  companyId: "company_id",

  isEnabled: "is_enabled"
}

userRoles = {
  id: "id", 
  userId: "user_id",
  role: "role"
}

serviceGroups = {
  id: "id",
  name: "name",
  companyId: "company_id"
}

services = {
  id: "id",
  uuid: "uuid",
  name: "name",
  companyId: "company_id",
  serviceGroupId: "service_group_id"
}

serviceImages = {
  id: "id",
  uuid: "uuid",
  serviceId: "service_id",
  imageUrl: "image_url",
  cloudinaryImagePublicId: "cloudinary_image_public_id"
}

serviceProviderCompanies = {
  id: "id",
  uuid: "uuid",
  companyName: "company_name"
}

locations = {
  id: "id",
  uuid: "uuid",
  serviceProviderCompanyId: "service_provider_company_id",
  name: "name",
  latitude: "latitude",
  longitude: "longitude",
  googlePlusCode: "google_plus_code",
  isVerified: "is_verified",
  isActive: "is_active"
}

consumerServiceRatings = {
  id: "id",
  consumerUserId: "consumer_user_id",
  serviceId: "service_id",
  serviceLocationId: "service_location_id",
  rating: "rating"
}
