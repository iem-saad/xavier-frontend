class ApplicationController < ActionController::Base
	before_action :initialize_backend_service
	before_action :check_for_invalid_model_or_operator

	def after_sign_in_path_for(resource)
	  dashboard_index_path
	end

	private def check_for_invalid_model_or_operator
		return redirect_to dashboard_index_path, alert: "Invalid Model Selected!" if params[:model_name].present? && !Rails.application.config.available_models.include?(params[:model_name])
		return redirect_to dashboard_index_path, alert: "Invalid Operator Selected!" if params[:operator].present? && !Rails.application.config.available_operators.include?(params[:operator])
		return redirect_to dashboard_index_path, alert: "Backend is Not Live Yet, Please Contact xavier.cfd@gmail.com!" if request.path.include?("project") && !@backend_serice.is_backend_live
	end

	private def initialize_backend_service
    @backend_serice ||= XavierBackendService.new
  end
end
