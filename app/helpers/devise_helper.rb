module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    messages = resource
                 .errors
                 .full_messages
                 .map { |msg| content_tag(:li, msg) }
                 .join
                 .gsub("Email not found",
                       "Oops! No account exists with that email. <br/> Did you sign up with a different email? <br/>Contact info@affinity.works if problem persists.")

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
