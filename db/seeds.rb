Origin.find_or_create_by(name: 'Action Network')
Origin.find_or_create_by(name: 'Facebook')
Origin.find_or_create_by(name: 'Affinity')

# ADMIN

admin = Person.create(family_name: 'Admin',
                      given_name: 'Test',
                      gender: 'Other',
                      password: 'password',
                      admin: true)

# NATIONAL GROUP

group = Group.create(name: 'National Network',
                     an_api_key: '7cc9eff8d105f3ff34c6bf7683abbec6',
                     creator: admin)

EmailAddress.create(address: 'test@admin.com',
                    primary: true,
                    person_id: admin.id)

Membership.create(person: admin,
                  group: group,
                  role: 'organizer')


# MEMBER 1

member1 = Person.create(family_name: 'Member',
                        given_name: 'Test',
                        gender: 'Other',
                        password: 'password')

EmailAddress.create(address: 'test@member.com',
                    primary: true,
                    person_id: member1.id)

Membership.create(person: member1,
                  group: group,
                  role: 'member')

# MEMBER 2

member2 = Person.create(family_name: 'member',
                        given_name: 'Test',
                        gender: 'Other',
                        password: 'password')

EmailAddress.create(address: 'member2@member.com',
                    primary: true,
                    person_id: member2.id)

Membership.create(person: member2,
                  group: group,
                  role: 'organizer')

# ORGANIZER

organizer = Person.create(family_name: 'Organizer',
                          given_name: 'Local',
                          gender: 'Other',
                          password: 'password')

EmailAddress.create(address: 'organizer@member.com',
                    primary: true,
                    person_id: organizer.id)


Membership.create(person: organizer,
                  group: group,
                  role: 'organizer')

# NATOINAL ORGANIZER

norganizer = Person.create(family_name: 'Organizer',
                           given_name: 'National',
                           gender: 'Other',
                           password: 'password')

EmailAddress.create(address: 'norganizer@member.com',
                    primary: true,
                    person_id: norganizer.id)

Membership.create(person: norganizer,
                  group: group,
                  role: 'organizer')

# AFFILIATIONS

affiliate_2 = Group.create(name: "Take Action SF",
                           an_api_key: '65ae2539627779838af580a3ba4ba411',
                           creator: organizer)

affiliate_3 = Group.create(name: "Ariba Carajo",
                           an_api_key: '88527d51a3911e403b8c978f3f7eb394',
                           creator: organizer)

affiliate = Group.create(name: 'Portland Commuinty Rising',
                         an_api_key: '7697d3813267b9ea9550648064dbc90b',
                         creator: organizer)

# CUSTOM SIGNUP FORM

GroupSignupForm.create(
  group: group,
  form_attributes: {
    name: 'signup_form_1',
    title: "Our group is great",
    description: "<ul> \
        <li>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.</li> \
        <li>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.</li> \
        <li>Pellentesque fermentum dolor. Aliquam quam lectus, facilisis auctor, ultrices ut, elementum vulputate, nunc.</li> \
      </ul>",
    call_to_action: 'Join the Best Group!'
  },
  person_input_group_attributes: {
    inputs: PersonInputGroup::VALID_INPUTS,
    required: PersonInputGroup::VALID_INPUTS.first
  },
  phone_input_group_attributes: {
    inputs: PhoneInputGroup::VALID_INPUTS
  },
  email_input_group_attributes: {
    inputs: EmailInputGroup::VALID_INPUTS,
    required: PersonInputGroup::VALID_INPUTS.first
  },
  address_input_group_attributes: {
    inputs: AddressInputGroup::VALID_INPUTS
  }
)

# SYNC GROUP

group.sync_with_action_network

# SYNC AFFILIATIONS

Affiliation.create(affiliated: affiliate, group: group)
Affiliation.create(affiliated: affiliate_2, group: group)
Affiliation.create(affiliated: affiliate_3, group: group)

affiliate.sync_with_action_network
affiliate_2.sync_with_action_network
affiliate_3.sync_with_action_network


# test facebook users:
# nkarntbiax_1498782998@tfbnw.net - mnm8;yDbzzsRuxvY
# ekcuwfbljf_1498782997@tfbnw.net - mnm8;yDbzzsRuxvY
# wbylbikbki_1498782996@tfbnw.net - mnm8;yDbzzsRuxvY
# mbuczyxbve_1498783000@tfbnw.net - mnm8;yDbzzsRuxvY
# quahayinav_1498782922@tfbnw.net - mnm8;yDbzzsRuxvY
