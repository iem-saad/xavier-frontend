require "rails_helper"

# - validates uniqueness of email
# - validates format of email
# - validates password complexity

RSpec.describe User, type: :model do
  let(:user) {build(:user)}
  let(:user_2) {build(:user)}

  context "validations" do
    it 'is valid' do
      expect(user).to be_valid
      expect(user_2).to be_valid
    end

    it "should have a valid password format" do
      user.password = '1234'
      expect(user).to be_invalid
      expect(user.errors[:password]).to_not be_empty
      user.password = 'abc'
      expect(user).to be_invalid
      expect(user.errors[:password]).to_not be_empty
      user.password = 'aA12345'
      expect(user).to be_valid
      expect(user.errors[:password]).to be_empty
    end

    it "should have a valid email format" do
      user.email = 'invalid_email'
      expect(user).to be_invalid
      expect(user.errors[:email]).to_not be_empty
    end

    it "shoud have an unique email" do
      user_2.save!
      user.email = user_2.email
      expect(user).to be_invalid
      expect(user.errors[:email]).to_not be_empty
    end
  end
end
