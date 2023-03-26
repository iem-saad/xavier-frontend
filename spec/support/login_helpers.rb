require 'devise'

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
  end
end

module FeatureHelpers
  def login_user
    before(:each) do
      @user = create(:user)
      login_as(@user, scope: :user)
    end
  end
end

RSpec.configure do |config|
  config.extend FeatureHelpers, type: :feature
end