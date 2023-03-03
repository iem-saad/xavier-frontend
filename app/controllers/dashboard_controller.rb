class DashboardController < ApplicationController
  before_action :protect_invalid_access

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
    type_dict = {"neuron_level": "neuron_layers", "weight_level": "edge-layers"}

    @layer_names = @backend_serice.get_layer_names(params[:model_name], type_dict[params[:operator].to_sym])
    @model_image = @backend_serice.get_model_img(params[:model_name])

    respond_to do |format|
      format.json { render json: op_type_dict[params[:model_name].to_sym].to_json }
    end
  end

  def selected_graphical_analysis
    return redirect_to specific_model_graph_eval_path(model_name: params[:model_name]), alert: "Please Select Atleast One Method!" if selected_analysis&.to_h&.length <= 1

    gather_analysis_data_from_backend()
  end

  def selected_tabular_analysis
    return redirect_to specific_model_table_eval_path(model_name: params[:model_name]), alert: "Please Select Atleast One Method!" unless params[:analysis].present?

    gather_analysis_data_from_backend()
  end

  def get_layer_weights
    @kernels = @backend_serice.get_layer_weights(params[:model_name], params[:layer])
    return redirect_to dashboard_index_path(model_name: params[:model_name]), alert: "Ops! Weights Not Found!" unless @kernels.present?
    @operator_list = @backend_serice.get_operator_names(1)
  end

  def compare_layer_weights
    @org_kernels = @backend_serice.get_layer_weights(params[:model_name], params[:layer])
    @mutated_kernels = @backend_serice.get_layer_weights("Mutant", params[:layer])
  end

  def put_layer_weights
    return redirect_to dashbaord_get_layer_weights_path(model_name: params[:model_name], operator: params[:operator], layer: params[:layer]), alert: "Error! Operator Value Not Selected!" if operator_params[:operator].eql?("change-neuron") && !operator_params[:op_value].present?
    #return redirect_to dashbaord_get_layer_weights_path(model_name: params[:model_name], operator: params[:operator], layer: params[:layer]), alert: "Error! Invalid Operator Selected!" if !operator_params[:modal_row].present? || !operator_params[:modal_col].present? || !operator_params[:modal_kernel].present?

    if params[:layer].include?("conv")
      response = @backend_serice.generate_mutant(params[:model_name], params[:layer], operator_params[:operator], operator_params[:op_value], operator_params[:modal_row], operator_params[:modal_col], operator_params[:modal_kernel])
    elsif params[:layer].include?("dense")
      response = @backend_serice.generate_mutant(params[:model_name], params[:layer], operator_params[:operator], operator_params[:op_value], operator_params[:modal_prev], operator_params[:modal_curr], 0)
    end
    return redirect_to dashbaord_get_layer_weights_path(model_name: params[:model_name], operator: params[:operator], layer: params[:layer]), notice: response.values[0]
  end

  private
    def selected_analysis
      params.require(:analysis).permit(:specificity, :class_accuracy, :f1_score, :recall, :precision, :auc, :sensitivity, :accuracy, :f_beta, :fbeta_range)
    end

    def operator_params
      params.require(:operator_type).permit(:modal_kernel, :modal_row, :modal_col, :operator, :op_value, :modal_prev, :modal_curr)
    end

    def protect_invalid_access
      return redirect_to new_user_session_path, alert: "Please Sign in to continue" unless current_user.present?
    end

    def gather_analysis_data_from_backend
      if selected_analysis[:f_beta].present? && selected_analysis[:fbeta_range].present?
        f_beta = selected_analysis[:fbeta_range].to_f
      else
        f_beta = 0.0
      end

      @original_analysis = @backend_serice.get_all_analysis_metrics(params[:model_name], f_beta)
      @mutated_analysis = @backend_serice.get_all_analysis_metrics("Mutant", f_beta)

      if selected_analysis[:specificity].present?
        @org_specificity = @original_analysis[1]["specificity"].values.map(&:to_f)
        @mutated_specificity = @mutated_analysis[1]["specificity"].values.map(&:to_f)
      end

      if selected_analysis[:class_accuracy].present?
        @org_class_accuracy = @original_analysis[0]["accuracy"].values.map(&:to_f)
        @mutated_class_accuracy = @mutated_analysis[0]["accuracy"].values.map(&:to_f)
      end

      if selected_analysis[:f1_score].present?
        @org_f1_scores = @original_analysis[5]["f1_score"].values.map(&:to_f)
        @mutated_f1_scores = @mutated_analysis[5]["f1_score"].values.map(&:to_f)
      end

      if selected_analysis[:recall].present?
        @org_recalls = @original_analysis[4]["recall"].values.map(&:to_f)
        @mutated_recalls = @mutated_analysis[4]["recall"].values.map(&:to_f)
      end

      if selected_analysis[:precision].present?
        @org_precision = @original_analysis[3]["precision"].values.map(&:to_f)
        @mutated_precision = @mutated_analysis[3]["precision"].values.map(&:to_f)
      end

      if selected_analysis[:sensitivity].present?
        @org_sensitivity = @original_analysis[2]["sensitivity"].values.map(&:to_f)
        @mutated_sensitivity = @mutated_analysis[2]["sensitivity"].values.map(&:to_f)
      end

      if selected_analysis[:auc].present?
        @org_auc = @original_analysis[6]["AUC"].values.map(&:to_f)
        @mutated_auc = @mutated_analysis[6]["AUC"].values.map(&:to_f)
      end

      if selected_analysis[:f_beta].present?
        @org_fbeta = @original_analysis[7]["F_beta"].values.map(&:to_f)
        @mutated_fbeta = @mutated_analysis[7]["F_beta"].values.map(&:to_f)
      end

      if selected_analysis[:accuracy].present?
        @org_accuracy = @backend_serice.get_model_metric(params[:model_name], 'model-accuracy').values.map(&:to_f)
        @mutated_accuracy = @backend_serice.get_model_metric("Mutant", 'model-accuracy').values.map(&:to_f)
      end
    end
end