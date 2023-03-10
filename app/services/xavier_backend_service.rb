class XavierBackendService < ApplicationService
  def get_model_names
    ['lenet5']
  end

  def get_layer_names(model, type)
    res = self.class.get("/#{type}/#{model}", {})
    JSON.parse(res)
  end

  def get_model_img(model)
    res = self.class.get("/model-image/#{model}", {})
  end

  def get_layer_weights(model, layer)
    if layer.include?("conv")
      res = self.class.get("/all-kernel-weights/#{model}/#{layer}", {})
      JSON.parse(res)
    elsif layer.include?("dense")
      res = self.class.get("/all-weights/#{model}/#{layer}", {})
      parsed_response = JSON.parse(res)
      parsed_response[0]["__ndarray__"]
    end
  end

  def get_model_metric(model, matric)
    res = self.class.get("/#{matric}/#{model}", {})
    JSON.parse(res)
  end

  def get_all_analysis_metrics(model, beta = 0)
    res = self.class.get("/report/#{model}/#{beta}", {})
    JSON.parse(res)
  end

  def get_operator_names(type)
    res = self.class.get("/operators-list/#{type}", {})
    JSON.parse(res)
  end

  def generate_mutant(model, layer, operator, op_value, row, col, kernel = 0)
    if layer.include?("conv")
      if operator.eql?("change-neuron")
        endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}/#{kernel}/#{op_value.to_f}"
      else
        endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}/#{kernel}"
      end
    elsif layer.include?("dense")
      if operator.eql?("change-edge")
        endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}/#{op_value.to_f}"
      else
        endpoint = "/#{operator}/#{model}/#{layer}/#{row}/#{col}"
      end
    end
    response = self.class.put(endpoint, headers: { "Content-Type" => 'application/json' })
  end

  def start_mutation_testing(p_id)
    res = self.class.get("/run/#{p_id}", {read_timeout: 1000000})
    JSON.parse(res)
  end
end