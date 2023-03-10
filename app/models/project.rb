class Project < ApplicationRecord
  belongs_to :user
  has_many :original_models, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validate :value_of_k
  

  store :hyper_params, accessors: [:model, :operator_type, :operator_name, :layer, :k_value, :operator_params]
  enum :status, { error: -1, unconfigured: 0, in_progress: 1, completed: 2 }
  scope :unconfigured, -> { where(status: "unconfigured") }
  scope :configured, -> { where.not(status: "unconfigured") }

  private def value_of_k
    if self.hyper_params.present? && self.hyper_params.dig("k_value").to_i <= 5
      errors.add :base, :invalid, message: "Value of K Must be greater than 5."
    end
  end
end
