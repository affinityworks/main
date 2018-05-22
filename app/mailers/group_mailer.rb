class GroupMailer < ApplicationMailer

  def join_group_email(person, group)
    @person = person; @group = group;
    mail(to: @person.primary_email_address, subject: "Welcome to #{@group.name}")
  end
end
