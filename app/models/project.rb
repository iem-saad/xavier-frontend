class Project < ApplicationRecord
  belongs_to :user
  has_many :original_models, dependent: :destroy

  store :hyper_params, accessors: [:model, :operator_type, :operator_name]
end
