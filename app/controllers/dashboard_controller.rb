class DashboardController < ApplicationController
	before_action :initialize_backend_service

	def index; end

	def mutation_testing
		@model_names = @backend_serice.get_model_names()
	end

	def get_model_details
		return redirect_to dashbaord_mutation_testing_path, alert: "Invalid Model Selected!" unless params[:model_selection][:model_name].present?

		@layer_names = @backend_serice.get_layer_names(params[:model_selection][:model_name])
	end


	private
		def initialize_backend_service
			@backend_serice ||= ModelDetailsService.new
		end
end