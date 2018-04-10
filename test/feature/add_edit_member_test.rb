require_relative "../test_helper"

class AddEditMember < FeatureTest
  let(:group){ groups(:fantastic_four) }
  let(:organizer){ people(:human_torch) }
  let(:person_count){ Person.count }
  let(:add_member_attrs) do
    {

    }
  end
  let(:edit_member_attrs) do
    {
      'First Name*' =>  'funny',
      'Last Name*'  =>  'cat',
      'Email*'      =>  'funn@cat.com',
      'Zip Code*'   =>  '99999',
      'Phone'       =>  '999-999-9999',
    }
  end

  describe "adding a member" do
    before do
      person_count
      login_as organizer
      visit "/groups/#{group.id}/members/new"
      fill_out_form('First Name*' =>  'serious',
                    'Last Name*'  =>  'person',
                    'Email*'      =>  'serious@person.com',
                    'Zip Code*'   =>  '11111',
                    'Phone'       =>  '111-111-1111')
      click_button 'Submit'
    end

    it "creates a new person" do
      Person.count.must_equal(person_count + 1)
    end

    it "makes person member of group" do
      group.members.last.must_equal Person.last
    end

    it "saves form entries" do
      p = Person.last
      p.given_name.must_equal 'serious'
      p.family_name.must_equal 'person'
      p.primary_email_address.must_equal 'serious@person.com'
      p.primary_personal_address.postal_code.must_equal '11111'
      p.primary_phone_number.must_equal '111-111-1111'
    end

    describe "editing member" do
      before do
        visit "/groups/#{group.id}/members/#{Person.last.id}/edit"
        fill_out_form('First Name*' =>  'funny',
                      'Last Name*'  =>  'cat',
                      'Email*'      =>  'funny@cat.com',
                      'Zip Code*'   =>  '22222',
                      'Phone'       =>  '222-222-2222')
        click_button 'Submit'
      end

      it "saves form entries" do
        p = Person.last
        p.given_name.must_equal 'funny'
        p.family_name.must_equal 'cat'
        p.primary_personal_address.postal_code.must_equal '22222'
        p.primary_email_address.must_equal 'funny@cat.com'
        p.primary_phone_number.must_equal '222-222-2222'
      end
    end
  end
end
