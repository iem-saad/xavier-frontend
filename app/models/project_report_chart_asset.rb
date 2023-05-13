class ProjectReportChartAsset < ApplicationRecord
  belongs_to :project
  belongs_to :user
  validates :matric_type, :model_no, :img_string, presence: true
end
