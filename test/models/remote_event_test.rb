require 'test_helper'

class RemoteEventTest < ActiveSupport::TestCase
  test "initizlize for_event" do
    new_fb_remote_event_hash = {"description"=>"Please join us for a night of dancing and community in celebration of Gemini births. DJ sets by\n\nDaneover\nHari Ziznewski\nThe High Kids (Carly B & Rap Class)\nDJ Sean P\nCommune\nJesse Mejia\nPerfect Health\n\nEarly birds will get snacks prepared by a couple local chefs. Cocktail punches will also be available. BYOB is encouraged for late night arrivals.\n\nThe event is being held in the Oak St. Building behind Sheridan’s. There is no cover, but for the safety of guests and the building, there will be a door person. To enter, you must be over 21 and know the password/theme of the party (GEMINI). Feel free to invite friends, especially the Gems!\n\nWe look forward to seeing you!", "end_time"=>"2017-06-03T05:00:00-0700", "name"=>"GEMINI PARTY 2017", "start_time"=>"2017-06-02T21:00:00-0700", "uid" => 'aksljvoz093'}

    found_fb_event = FacebookEvent.find_or_initialize_for_event(events(:one).id, new_fb_remote_event_hash)
    assert_kind_of RemoteEvent, found_fb_event
    assert_equal events(:one).id, found_fb_event.event_id
  end
end
