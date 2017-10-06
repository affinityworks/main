# app/helpers/subdomain_helper.rb

module SubdomainHelper
    def with_subdomain(subdomain)
      subdomain = (subdomain || "")
      subdomain += "." unless subdomain.empty?
      host = Rails.application.config.action_mailer.default_url_options[:host]
      [subdomain, host].join
    end
    
    def url_for(options = nil)
      if options.kind_of?(Hash) && options.has_key?(:subdomain)
        options[:host] = with_subdomain(options.delete(:subdomain))
      end
      super
    end
  end