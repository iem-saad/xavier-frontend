class DashboardController < ApplicationController
	before_action :initialize_backend_service

	def index; end
	def mutation_analysis; end
	def select_mutation_operator; end
	def graphical_analysis; end
	def model_graphical_analysis; end
	def tabular_analysis; end
	def model_tabular_analysis; end

	def mutation_testing
		@model_names = @backend_serice.get_model_names()
	end

	def get_model_details
		return redirect_to dashbaord_mutation_testing_path, alert: "Invalid Model Selected!" unless params[:model_name].present?

		@layer_names = @backend_serice.get_layer_names(params[:model_name])
		@model_image = @backend_serice.get_model_img(params[:model_name])
	end

	def selected_graphical_analysis
		return redirect_to specific_model_graph_eval_path(model_name: params[:model_name]), alert: "Please Select Atleast One Method!" unless params[:analysis].present?

		if selected_analysis[:specificity].present?
			@org_specificity = @backend_serice.get_model_metric(params[:model_name], 'specificity').values.map(&:to_f)
			@mutated_specificity = @backend_serice.get_model_metric("Mutant", 'specificity').values.map(&:to_f)
		end

		if selected_analysis[:class_accuracy].present?
			@org_class_accuracy = @backend_serice.get_model_metric(params[:model_name], 'class-accuracy').values.map(&:to_f)
			@mutated_class_accuracy = @backend_serice.get_model_metric("Mutant", 'class-accuracy').values.map(&:to_f)
		end

		if selected_analysis[:f1_score].present?
			@org_f1_scores = @backend_serice.get_model_metric(params[:model_name], 'f1-score').values.map(&:to_f)
			@mutated_f1_scores = @backend_serice.get_model_metric("Mutant", 'f1-score').values.map(&:to_f)
		end

		if selected_analysis[:recall].present?
			@org_recalls = @backend_serice.get_model_metric(params[:model_name], 'recall').values.map(&:to_f)
			@mutated_recalls = @backend_serice.get_model_metric("Mutant", 'recall').values.map(&:to_f)
		end

		if selected_analysis[:precision].present?
			@org_precision = @backend_serice.get_model_metric(params[:model_name], 'precision').values.map(&:to_f)
			@mutated_precision = @backend_serice.get_model_metric("Mutant", 'precision').values.map(&:to_f)
		end

		if selected_analysis[:sensitivity].present?
			@org_sensitivity = @backend_serice.get_model_metric(params[:model_name], 'sensitivity').values.map(&:to_f)
			@mutated_sensitivity = @backend_serice.get_model_metric("Mutant", 'sensitivity').values.map(&:to_f)
		end

		if selected_analysis[:auc].present?
			@org_auc = @backend_serice.get_model_metric(params[:model_name], 'auc').values.map(&:to_f)
			@mutated_auc = @backend_serice.get_model_metric("Mutant", 'auc').values.map(&:to_f)
		end

		if selected_analysis[:accuracy].present?
			@org_accuracy = @backend_serice.get_model_metric(params[:model_name], 'model-accuracy').values.map(&:to_f)
			@mutated_accuracy = @backend_serice.get_model_metric("Mutant", 'model-accuracy').values.map(&:to_f)
		end
	end

	def selected_tabular_analysis
		return redirect_to specific_model_table_eval_path(model_name: params[:model_name]), alert: "Please Select Atleast One Method!" unless params[:analysis].present?

		if selected_analysis[:specificity].present?
			@org_specificity = @backend_serice.get_model_metric(params[:model_name], 'specificity').values.map(&:to_f)
			@mutated_specificity = @backend_serice.get_model_metric("Mutant", 'specificity').values.map(&:to_f)
		end

		if selected_analysis[:class_accuracy].present?
			@org_class_accuracy = @backend_serice.get_model_metric(params[:model_name], 'class-accuracy').values.map(&:to_f)
			@mutated_class_accuracy = @backend_serice.get_model_metric("Mutant", 'class-accuracy').values.map(&:to_f)
		end

		if selected_analysis[:f1_score].present?
			@org_f1_scores = @backend_serice.get_model_metric(params[:model_name], 'f1-score').values.map(&:to_f)
			@mutated_f1_scores = @backend_serice.get_model_metric("Mutant", 'f1-score').values.map(&:to_f)
		end

		if selected_analysis[:recall].present?
			@org_recalls = @backend_serice.get_model_metric(params[:model_name], 'recall').values.map(&:to_f)
			@mutated_recalls = @backend_serice.get_model_metric("Mutant", 'recall').values.map(&:to_f)
		end

		if selected_analysis[:precision].present?
			@org_precision = @backend_serice.get_model_metric(params[:model_name], 'precision').values.map(&:to_f)
			@mutated_precision = @backend_serice.get_model_metric("Mutant", 'precision').values.map(&:to_f)
		end

		if selected_analysis[:sensitivity].present?
			@org_sensitivity = @backend_serice.get_model_metric(params[:model_name], 'sensitivity').values.map(&:to_f)
			@mutated_sensitivity = @backend_serice.get_model_metric("Mutant", 'sensitivity').values.map(&:to_f)
		end

		if selected_analysis[:auc].present?
			@org_auc = @backend_serice.get_model_metric(params[:model_name], 'auc').values.map(&:to_f)
			@mutated_auc = @backend_serice.get_model_metric("Mutant", 'auc').values.map(&:to_f)
		end

		if selected_analysis[:accuracy].present?
			@org_accuracy = @backend_serice.get_model_metric(params[:model_name], 'model-accuracy').values.map(&:to_f)
			@mutated_accuracy = @backend_serice.get_model_metric("Mutant", 'model-accuracy').values.map(&:to_f)
		end
	end

	def get_layer_weights
		@kernels = @backend_serice.get_layer_weights(params[:model_name], params[:layer])
	end

	def compare_layer_weights
		@org_kernels = @backend_serice.get_layer_weights(params[:model_name], params[:layer])
		@mutated_kernels = @backend_serice.get_layer_weights("Mutant", params[:layer])
	end

	private
		def initialize_backend_service
			@backend_serice ||= ModelDetailsService.new
		end

		def selected_analysis
			params.require(:analysis).permit(:specificity, :class_accuracy, :f1_score, :recall, :precision, :auc, :sensitivity, :accuracy)
		end
end