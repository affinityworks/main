class OrganizerMailer < ApplicationMailer

  def new_subgroup_email(organizer, subgroup)
    @organizer = organizer; @subgroup = subgroup;
    mail(to: @organizer.primary_email_address,
         subject: "Welcome to #{@subgroup.name}")

  end
end
