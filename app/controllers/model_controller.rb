class ModelController < ApplicationController
	
  def download_org_model
    model = OriginalModel.find params[:id]

    send_data  Base64.encode64(model.file), filename: "original_model_#{params[:index]}.bin", disposition: 'attachment'
  end

  def download_mutated_model
    model = OriginalModel.find params[:id]
    mutated_model = model.mutated_model

    send_data  Base64.encode64(mutated_model.file), filename: "mutated_model_#{params[:index]}.bin", disposition: 'attachment'
  end
end
