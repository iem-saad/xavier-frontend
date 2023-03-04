class Project < ApplicationRecord
  belongs_to :user
  has_many :original_models, dependent: :destroy

  store :hyper_params, accessors: [:model, :operator_type, :operator_name, :layer, :k_value, :operator_params]
  enum :status, { error: -1, before_prgress: 0, in_progress: 1, completed: 2 }
end
