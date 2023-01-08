class XavierBackendService < ApplicationService
  def get_model_names
    ['lenet5']
  end

  def get_layer_names(model)
    res = self.class.get("/neuron_layers/#{model}", {})
    JSON.parse(res)
  end

  def get_model_img(model)
    res = self.class.get("/model-image/#{model}", {})
  end

  def get_layer_weights(model, layer)
    if layer.include?("conv")
      res = self.class.get("/all-kernel-weights/#{model}/#{layer}", {})
      JSON.parse(res)
    end
  end

  def get_model_metric(model, matric)
    res = self.class.get("/#{matric}/#{model}", {})
    JSON.parse(res)
  end

  def get_operator_names(type)
    res = self.class.get("/operators-list/#{type}", {})
    JSON.parse(res)
  end

  def generate_mutant(model, layer, operator, op_value, row, col, kernel)
    if operator.eql?("change-neuron")
      # binding.pry
      endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}/#{kernel}/#{op_value.to_f}"
    else
      endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}/#{kernel}"
    end
    response = self.class.put(endpoint,headers: { "Content-Type" => 'application/json' })
  end
end