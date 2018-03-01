class OrganizerMailer < ApplicationMailer

  def new_subgroup_email(organizer, subgroup, form)
    @organizer = organizer; @subgroup = subgroup, @form = form
    mail(to: @user.primary_email_address,
         subject: "Welcome to #{@subgroup} name!")

  end
end
