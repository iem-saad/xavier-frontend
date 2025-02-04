class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy select_layer select_mutant_location start_mutation_testing restart_mutation_testing ]
  before_action :set_op_type_dict
  skip_before_action :verify_authenticity_token, only: [:report_chart_assets]
  layout 'pdf', only: [:export_tabular_analysis_report, :export_graphical_analysis_report]


  # GET /projects or /projects.json
  def index
    @projects = current_user&.projects&.configured&.order(:id)
    @un_conf_projects = current_user&.projects&.unconfigured
    @failed_projects = current_user&.projects&.error
  end

  # GET /projects/1 or /projects/1.json
  def show
    @backend_serice.is_backend_live
  end

  # GET /projects/new
  def new
    @project = Project.new(user: current_user)
    @model_names = @backend_serice.get_model_names()
    @operator_types = nil
  end

  # GET /projects/1/edit
  def edit
    @model_names = @backend_serice.get_model_names()
    @operator_types = @op_type_dict[@project.hyper_params["model"].to_sym]
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @model_names = @backend_serice.get_model_names()
    
    @operator_types = @op_type_dict[@project.hyper_params["model"].to_sym]

    respond_to do |format|
      if @project.save
        format.html { redirect_to select_layer_path(id: @project.id), notice: "Project was successfully created, Please Configure it for further processing." }
        format.json { render :show, status: :created, location: @project }
      else
        flash[:alert] = "Unable to Create Project."
        format.html { render :new, alert:  }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_model_applicable_operator
    respond_to do |format|
      format.json { render json: @op_type_dict[params[:model_name].to_sym].to_json }
    end
  end

  def get_model_applicable_operator_names
    op_name_dict = {"lenet5": {"neuron_level": 1, "weight_level": 2}}
    @operator_list = @backend_serice.get_operator_names(op_name_dict[params[:model_name].to_sym][params[:operator].to_sym])

    respond_to do |format|
      format.json { render json: @operator_list.to_json }
    end
  end

  def select_layer
    type_dict = {"neuron_level": "neuron_layers", "weight_level": "edge-layers", "bias_level": "bias_layers"}

    @model_name = @project.hyper_params&.dig("model")
    @operator_type = @project.hyper_params&.dig("operator_type")
    @layer_names = @backend_serice.get_layer_names(@model_name, type_dict[@operator_type&.to_sym])
    @model_image = @backend_serice.get_model_img(@model_name)
  end

  def select_mutant_location
    @project.hyper_params.update("layer": params[:layer])
    @project.save
    @operator_list = @backend_serice.get_operator_names(1)
    @operator_list_cbv = {"change-bias-value": "Change Bias Value", "block-bias-value": "Block Bias Value", "mul-inverse-bias-value": "Multiplicative Inverse of Bias Value", "additive-inverse-bias-value": "Additive Inverse of Bias Value"}

    if @project.hyper_params.dig("operator_type").eql?("bias_level")
      @kernels = @backend_serice.get_bias_weights(@project.hyper_params&.dig("model"), params[:layer])
    else
      @kernels = @backend_serice.get_layer_weights(@project.hyper_params&.dig("model"), params[:layer])
    end
    return redirect_to projects_path, alert: "Ops! Weights Not Found!" unless @kernels.present?
  end

  def export_tabular_analysis_report
    @project = Project.find(params[:id])
    
    respond_to do |format|
      format.html do
        BackendMailer.send_evaluation_report(@project, "tabular").deliver_later
        return redirect_to project_path(@project), notice: "Evluation Report Exportation is in progress, you will recieve an email upon completion."
      end
    end
  end

  def export_graphical_analysis_report
    @project = Project.find(params[:id])
   
    respond_to do |format|
      format.html do
        BackendMailer.send_evaluation_report(@project, "graphical").deliver_later
        return redirect_to project_path(@project), notice: "Evluation Report Exportation is in progress, you will recieve an email upon completion."
      end
    end
  end

  def report_chart_assets
    img_asset = ProjectReportChartAsset.where(user_id: params[:user_id], project_id: params[:project_id], matric_type: params[:r_type], model_no: params[:index]).first_or_initialize
    if params[:image_data].length > 20
      img_asset.img_string = params[:image_data]
      img_asset.save!
    end

    render plain: 'OK'
  end

  def start_mutation_testing
    return redirect_to select_mutant_location_path(id: @project.id), alert: "Error! Operator Value Not Selected!" if operator_params[:operator].eql?("change-neuron") && !operator_params[:op_value].present?
    layer = @project.hyper_params&.dig("layer")
    model = @project.hyper_params&.dig("model")
    if layer.include?("conv")
      # response = @backend_serice.generate_mutant(model, layer, operator_params[:operator], operator_params[:op_value], operator_params[:modal_row], operator_params[:modal_col], operator_params[:modal_kernel])
      @project.hyper_params.update(operator_params: operator_params.to_h)
    elsif layer.include?("dense")
      # response = @backend_serice.generate_mutant(model, layer, operator_params[:operator], operator_params[:op_value], operator_params[:modal_prev], operator_params[:modal_curr], 0)
      @project.hyper_params.update(operator_params: operator_params.to_h)
    end
    @project.in_progress!
    @project.save
    MutationTestingJob.perform_later(@project)
    return redirect_to projects_path(), notice: "Mutation Testing Started, You will be Notified when processing is complete."
  end

  def restart_mutation_testing
    @project.in_progress!
    @project.save
    MutationTestingJob.perform_later(@project)
    return redirect_to projects_path(), notice: "Mutation Testing Started, You will be Notified when processing is complete."
  end

  def make_notifications_seen
    current_user.notifications.unseen.update_all(seen: true)
  end

  def mutation_analysis
    @projects = current_user.projects.completed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.fetch(:project, {}).permit(:name, :description, :operator_type, :operator_name, :user_id, :model, :k_value)
    end

    def operator_params
      params.require(:operator_type).permit(:modal_kernel, :modal_row, :modal_col, :operator, :op_value, :modal_prev, :modal_curr)
    end

    def set_op_type_dict
      @op_type_dict ||= {"lenet5": ["neuron_level","weight_level", "bias_level"]}
    end
end
