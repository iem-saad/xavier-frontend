class DashboardController < ApplicationController
	before_action :initialize_backend_service

	def index; end

	def mutation_testing
		@model_names = @backend_serice.get_model_names()
	end

	def get_model_details
		return redirect_to dashbaord_mutation_testing_path, alert: "Invalid Model Selected!" unless params[:model_name].present?

		@layer_names = @backend_serice.get_layer_names(params[:model_name])
	end

	def mutation_analysis; end
	def select_mutation_operator; end
	def graphical_analysis; end
	def tabular_analysis; end

	def get_layer_weights
		@backend_serice.get_layer_weights(params[:model_name], params[:layer])
	end

	private
		def initialize_backend_service
			@backend_serice ||= ModelDetailsService.new
		end
end