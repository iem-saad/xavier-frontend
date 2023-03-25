require "rails_helper"

# - validates presence of name
# - validates value of k

RSpec.describe Project, type: :model do
  let(:project) {build(:project)}

  context "validations" do
    it 'is valid' do
      expect(project).to be_valid
    end

    it "should have a valid name" do
      project.name = ''
      expect(project).to be_invalid
      expect(project.errors[:name]).to_not be_empty
    end

    it "value of k Can't be Empty" do
      project.hyper_params["k_value"] = nil
      expect(project).to be_invalid
      expect(project.errors[:base]).to_not be_empty
    end

    it "value of k must be greater than 5" do
      project.hyper_params["k_value"] = 2
      expect(project).to be_invalid
      expect(project.errors[:base]).to_not be_empty
    end
  end
end
