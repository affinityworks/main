class EmailShare < ApplicationRecord
  belongs_to :share_page
end

#i'm pretty sure we'll want to assocate with a sender and recever person
