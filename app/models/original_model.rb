class OriginalModel < ApplicationRecord
  belongs_to :project
  has_one :mutated_model
end
