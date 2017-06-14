require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'post #create' do
    person = people(:organizer)
    sign_in person

    membership = person.memberships.first
    text = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'

    assert_difference 'membership.notes.count', 1 do
      post notes_url(note: {
        text: text,
        resource_type: 'membership',
        resource_id: membership.id
        }), as: :json
    end

    assert_response :success
    note = membership.notes.last

    assert_equal note.author, person
    assert_equal note.text, text
  end
end
