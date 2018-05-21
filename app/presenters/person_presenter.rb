class PersonPresenter
  class << self
    def formatted_error(msg)
      msg
        .gsub("Email addresses address", "Email address")
        .gsub("Personal addresses postal code", "Zip code")
        .gsub("Phone numbers number", "Phone number")
        .gsub("Memberships person phone numbers number", "Phone number")
        .gsub("Memberships person personal addresses postal code", "Zip code")
        .gsub("Memberships person email addresses address", "Email address")
        .gsub("Memberships group has already been taken", "")
        .gsub("Memberships person has already been taken", "")
        .gsub("Memberships person password", "Password")
    end
  end
end
