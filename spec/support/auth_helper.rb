require 'spec_helper'

module AuthHelper
  def login_user
   @request.env["devise.mapping"] = Devise.mappings[:user]
   @user = create(:user)
   sign_in @user
  end
end
