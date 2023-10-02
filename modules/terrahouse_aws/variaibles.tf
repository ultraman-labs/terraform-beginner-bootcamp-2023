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

variable "index_html_filepath" {
  type        = string
  description = "The file path of the index.html file"
  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The index_html_filepath must be a valid file path ending with .html."
  }
}

variable "error_html_filepath" {
  type        = string
  description = "The file path of the error.html file"
  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The error_html_filepath must be a valid file path ending with .html."
  }
}

variable "content_version" {
  type        = number
  description = "The version of the content, starting at 1."

  validation {
    condition     = var.content_version >= 1
    error_message = "The content_version must be an integer starting at 1."
  }
}
