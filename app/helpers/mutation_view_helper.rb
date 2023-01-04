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
end