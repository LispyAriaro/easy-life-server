module Constants.TableColumns (
  users, userRoles,
  services, serviceCategories, serviceImages, serviceProviderCompanies,
  locations, consumerServiceRatings
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
  createdBy: "created_by",

  isActive: "is_active"
}

userRoles = {
  id: "id",
  userId: "user_id",
  role: "role"
}

services = {
  id: "id",
  uuid: "uuid",
  name: "name",
  description: "description",
  companyId: "company_id",
  serviceCategoryId: "service_category_id",
  isActive: "is_active",
  price: "price"
}

serviceCategories = {
  id: "id",
  uuid: "uuid",
  name: "name"
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
  companyName: "company_name",
  isActive: "is_active"
}

locations = {
  id: "id",
  uuid: "uuid",
  companyId: "company_id",
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
  rating: "rating",
  comment: "comment"
}
