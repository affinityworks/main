
rails generate Pperson identifiers:string family_name:string given_name:string additional_name:string honorific_prefix:string honorific_sufix:string gender:enum gender_identity:string party_identification:string source:string ethnicities:string languages_spoken:string birthdate:date employer:string employer_id:integer custom_fields:text created_date:datetime modified_date:datetime --timestamps




Things to note:

Array strings: ethnicities, languages_spoken

rails generate


Location:
Type: employer / postal / event

rails generate model Address venue:string address_lines:string locality:string region:string postal_code:string country:string location_id:integer status:string primary:boolean address_type:string occupation:string --timestamps

status is an enumb of 'Potential', 'Verified', 'Bad'

Email Addresses




rails generate model EmailAddress primary:boolean address:string address_type:string status:string --timestamps

enums: address_type and status

rails generate model PhoneNumber primary:boolean number:string extension:string description:string number_type:string operator:string country:string sms_capable:boolean do_not_call:boolean --timestamps


rails generate model Profile provider:string profile_id:string url:string handle:string --timestamps



rails generate model Event origin_system:string name:string title:string description:string summary:string browser_url:string type:string ticket_levels:string featured_image_url:string total_accepted:integer total_tickets:integer total_amount:float status:string instructions:string start_date:datetime end_date:datetime all_day_date:date all_day:boolean capacity:integer guests_can_invite_others:boolean transparency:string visibility:string ticket_levels:references address:references reminders:references  --timestamps

rails generate model TicketLevel title:string description:string amount:float currency:string limit:integer total_tickets:integer total_amount:float --timestamps

rails generate model Attendance origin_system:string action_date:datetime status:string attended:boolean comment:string --timestamps

rails generate model ReferrerData source:string referrer:string website:string url:string --timestamps

rails generate model Ticket title:string description:string amount:float currency:string attended:string --timestamps

rails generate model AdvocacyCampaign origin_system:string name:string title:string description:string summary:string targets:string browser_url:string featured_image_url:string total_outreaches:integer type:string --timestamps


rails generate model Question origin_system:string name:string title:string description:string summary:string question_type:string --timestamps

rails generate model Canvass origin_system:string action_date:datetime contact_type:string imput_type:string sucess:boolean status_code:string
canvasser:references target:references canvassing_effort:references --timestamps

rails generate model CanvassingEffort origin_system:string name:string title:string description:string summary:string start_time:datetime end_time:datetime type:string total_canvasses:integer --timestamps


rails generate model Donation origin_system:string action_date:datetime amount:number credited_amount:number created_date:datetime currency:string subscription_instance:string voided:boolean voided_date:datetime url:string referrer_data:references person:references fundraising_page:references attendance:references --timestamps

rails generate model Recipient display_name:string legal_name:string amount:float donation:references --timestamps

rails generate model Payment method:string reference_number:string authorization_stored:boolean donation:references --timestamps

rails generate model FundraisingPage origin_system:string name:string title:string description:string summary:string browser_url:string featured_image_url:string total_donations:integer total_amount:float currency:string person:references --timestamps

rails generate model Outreach origin_system:string action_date:datetime type:string duration:integer subject:string message:string referrer_data:references --timestamps

rails generate model Target title:string organization:string given_name:string family_name:string ocdid:string --timestamps

#create_table :outreaches_targets, id: false do |t|
#  t.belongs_to :target, index: true
#  t.belongs_to :outreach, index: true
#end


rails generate model Petition origin_system:string name:string title:string description:string summary:string browser_url:string featured_image_url:string petition_text:string total_signatures:integer --timestamps

#create_table :petitions_targets, id: false do |t|
#  t.belongs_to :target, index: true
#  t.belongs_to :petition, index: true
#end

rails generate model Signature origin_system:string action_date:datetime comments:string referrer_data:references petition:references person:references --timestamps

rails generate model Answer action_date:datetime value:string responses:references --timestamps

rails generate model Question origin_system:string name:string title:string description:string summary:string question_type:string creator:references mondified_by:references --timestamps

rails generate model Response key:string name:string title:string --timestamps

#create_table :questions_reponses, id: false do |t|
#  t.belongs_to :question, index: true
#  t.belongs_to :response, index: true
#end

rails generate model Script origin_system:string name:string title:string description:string summary:string person:references creator:references canvassing_effort:references --timestamps


rails generate model ScriptQuestion sequence:integer question:references script:references --timestamps



rails generate model SharePage origin_system:string name:string title:string description:string summary:string browser_url:string share_url:string total_shares:integer creator:references modified_by:references --timestamps

rails generate model FacebookShare share_page:references title:string description:string image:string --timestamps

rails generate model TwitterShare share_page:references message:string description:total_shares --timestamps

rails generate model EmailShare share_page:references subject:string body:string description:total_shares --timestamps



rails generate model Form origin_system:string name:string title:string description:string summary:string call_to_action:string browser_url:string featured_image_url:string total_submissions:integer person:references creator:references submissions:references --timestamps

rails generate model Submission origin_system:string action_date:datetime references:referrer_data references:person references:form --timestamps


rails generate model Query origin_system:string name:string title:string description:string summary:string browser_url:string total_results:integer creator:references modified_by:references results:references --timestamps


rails generate model Membership group:references person:references role:string --timestamps
