class CreateProjectReportChartAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :project_report_chart_assets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :matric_type, null: false
      t.integer :model_no, null:false
      t.text :img_string, null: false

      t.timestamps
    end
  end
end
