class AddFieldsToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :user, index: true
    add_reference :notifications, :project, index: true
    add_column :notifications, :text, :string
    add_column :notifications, :n_type, :integer, default: 0
    add_column :notifications, :seen, :boolean, default: false
  end
end
