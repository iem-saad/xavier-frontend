class AddResultsInProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :results, :jsonb
  end
end
