library(rebus)
contact <- c("Call me at 555-555-0191", "123 Main St", "(555) 555 0191", "Phone: 555.555.0191 Mobile: 555.555.0192")
separator <-  char_class("-.() ")

# Create three digit pattern

three_digits <- DGT %R% DGT %R% DGT

# Create four digit pattern

four_digits <- DGT %R% DGT %R% DGT %R% DGT

phone_pattern <- optional(OPEN_PAREN) %R%
  three_digits %R%
  zero_or_more(separator) %R%
  three_digits %R% 
  zero_or_more(separator) %R%
  four_digits
