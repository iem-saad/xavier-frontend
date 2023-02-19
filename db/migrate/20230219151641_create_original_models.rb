class CreateOriginalModels < ActiveRecord::Migration[7.0]
  def change
    create_table :original_models do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.binary :file, null: false
      t.jsonb :matrices, default: {}
      t.timestamps
    end
  end
end
