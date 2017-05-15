group = Group.create(name: 'Test Group', an_api_key: 'c96dc7a808ed80fca8bb4953f8ac10bf')
admin = Person.create(family_name: 'Admin', given_name: 'Test', password: 'password', admin: true)
admin.email_addresses(EmailAddress.create(address: 'test@admin.com'))
member = Person.create(family_name: 'Member', given_name: 'Test', password: 'password')
member.email_addresses(EmailAddress.create(address: 'test@member.com'))
Membership.create(person: member, group: group, role: 'member')
organizer = Person.create(family_name: 'Organizer', given_name: 'Test', password: 'password')
member.email_addresses(EmailAddress.create(address: 'organizer@member.com'))
Membership.create(person: organizer, group: group, role: 'organizer')

group.sync_with_action_network
