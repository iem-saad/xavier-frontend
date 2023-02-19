class Project < ApplicationRecord
  belongs_to :user
  has_many :original_models, dependent: :destroy
end
