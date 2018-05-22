class GroupMailer < ApplicationMailer

  def create_group_email(organizer, subgroup)
    @organizer = organizer; @subgroup = subgroup;
    mail(to: @organizer.primary_email_address,
         subject: "Welcome to #{@subgroup.name}")

  end
end
