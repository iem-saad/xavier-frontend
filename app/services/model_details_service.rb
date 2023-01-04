class ModelDetailsService < ApplicationService
	def get_model_names
		['lenet5']
	end

	def get_layer_names(model)
		res = self.class.get("/neuron_layers/#{model}", {})
		JSON.parse(res)
	end
end