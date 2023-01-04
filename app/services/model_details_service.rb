class ModelDetailsService < ApplicationService
	def get_model_names
		['lenet5']
	end

	def get_layer_names(model)
		res = self.class.get("/neuron_layers/#{model}", {})
		JSON.parse(res)
	end

	def get_layer_weights(model, layer)
		if layer.include?("conv")
			res = self.class.get("/kernel-weights/#{model}/#{layer}", {})
			JSON.parse(res)
		end
	end

	def get_model_metric(model, matric)
		res = self.class.get("/#{matric}/#{model}", {})
		JSON.parse(res)
	end
end