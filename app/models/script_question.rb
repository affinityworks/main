class ScriptQuestion < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :script, optional: true
end
