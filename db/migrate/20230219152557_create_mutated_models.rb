class CreateMutatedModels < ActiveRecord::Migration[7.0]
  def change
    create_table :mutated_models do |t|
      t.references :original_model, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.binary :file, null: false
      t.jsonb :matrices, default: {}
      t.timestamps
    end
  end
end
