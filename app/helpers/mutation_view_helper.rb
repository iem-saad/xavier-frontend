module MutationViewHelper

  def color_according_to_layer(layer_name)
    return "#FFD166" if layer_name.include?("conv")
    return "#EF476F" if layer_name.include?("average")
    return "#06D6A0" if layer_name.include?("flatten")
    return "#118AB2" if layer_name.include?("dense")

    return "#FFD166"
  end

  def current_active_tab(url)
    return "active" if url == request.url
  end

  def operator_conf(project)
    if project.hyper_params.dig("layer").include?("conv")
      "You have applied #{project.hyper_params.dig("operator_params")["operator"]} operator on #{project.hyper_params.dig("layer")} at kernel #{project.hyper_params.dig("operator_params")["modal_kernel"]}, row #{project.hyper_params.dig("operator_params")["modal_row"]} and column #{project.hyper_params.dig("operator_params")["modal_col"]}."
    else
      "You have applied #{project.hyper_params.dig("operator_params")["operator"]} operator on #{project.hyper_params.dig("layer")} at previous edge #{project.hyper_params.dig("operator_params")["modal_prev"]}, current edge #{project.hyper_params.dig("operator_params")["modal_curr"]}."
    end
  end
end