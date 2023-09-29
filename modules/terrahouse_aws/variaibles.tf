variable "user_uuid" {
  description = "UUID for the user"
  
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "Invalid user UUID format. Please use a valid UUID."
   }
}

variable "bucket_name" {
  description = "The UUID of the user"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Invalid bucket name. It must be between 3 and 63 characters, and can only contain lowercase letters, numbers, hyphens, and periods."
  }
}