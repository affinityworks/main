
admin = Person.create(family_name: 'Admin', given_name: 'Test', password: 'password', admin: true)
group = Group.create(name: 'National Network', an_api_key: '7cc9eff8d105f3ff34c6bf7683abbec6', creator: admin)

admin_email_address = EmailAddress.create(address: 'test@admin.com', primary: true, person_id: admin.id)
Membership.create(person: admin, group: group, role: 'organizer')

member1 = Person.create(family_name: 'Member', given_name: 'Test', password: 'password')
member1_email_address = EmailAddress.create(address: 'test@member.com', primary: true, person_id: member1.id)
Membership.create(person: member1, group: group, role: 'member')

member2 = Person.create(family_name: 'member', given_name: 'Test', password: 'password')
member2_email_address = EmailAddress.create(address: 'member2@member.com', primary: true, person_id: member2.id)
Membership.create(person: member2, group: group, role: 'organizer')

organizer = Person.create(family_name: 'Organizer', given_name: 'Local', password: 'password')
organizer_email_address = EmailAddress.create(address: 'organizer@member.com', primary: true, person_id: organizer.id)
Membership.create(person: organizer, group: group, role: 'organizer')

norganizer = Person.create(family_name: 'Organizer', given_name: 'National', password: 'password')
norganizer_email_address = EmailAddress.create(address: 'norganizer@member.com', primary: true, person_id: norganizer.id)
Membership.create(person: norganizer, group: group, role: 'organizer')

affiliate_2 = Group.create(name: "Take Action SF", an_api_key: '65ae2539627779838af580a3ba4ba411', creator: organizer)
affiliate_3 = Group.create(name: "Ariba Carajo", an_api_key: '88527d51a3911e403b8c978f3f7eb394', creator: organizer)
affiliate = Group.create(name: 'Portland Commuinty Rising', an_api_key: '7697d3813267b9ea9550648064dbc90b', creator: organizer)

group.sync_with_action_network

Affiliation.create(affiliated: affiliate, group: group)
Affiliation.create(affiliated: affiliate_2, group: group)
Affiliation.create(affiliated: affiliate_3, group: group)

affiliate.sync_with_action_network
affiliate_2.sync_with_action_network
affiliate_3.sync_with_action_network
