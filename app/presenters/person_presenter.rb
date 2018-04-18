class PersonPresenter
  class << self
    def formatted_error(msg)
      msg
        .gsub("Email addresses address", "Email address")
        .gsub("Personal addresses postal code", "Zip code")
        .gsub("Phone numbers number", "Phone number")
    end
  end
end
