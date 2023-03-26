require 'rails_helper'
include AuthHelper

RSpec.describe HomeController, type: :controller do
  describe 'GET home#index' do
    subject { get :index }

    context 'with logged in user' do
      before(:each) do
        login_user
      end

      it 'renders the index template' do
        expect(subject).to render_template(:index)
      end
    end

    context 'without logged in user' do
      it 'render the index template' do
        expect(subject).to render_template(:index)
      end
    end
  end
end