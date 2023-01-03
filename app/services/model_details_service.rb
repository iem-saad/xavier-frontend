class ModelDetailsService < ApplicationService
	def get_model_names
		['lenet5']
	end

	def get_layer_names(model)
		['conv2d', 'average_pooling2d', 'conv2d_1', 'average_pooling2d_1', 'flatten', 'dense', 'dense_1', 'dense_2']
	end
end