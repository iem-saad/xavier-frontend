# frozen_string_literal: true
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :project

  scope :notifications_between, ->(start_date, end_date) { where(created_at: Date.parse(start_date).beginning_of_day .. Date.parse(end_date).end_of_day )}
  scope :unseen, -> { where(seen: false) }
  enum :n_type, { success: 0, warning: 1, danger: 2 }
end
