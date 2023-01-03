class DashboardController < ApplicationController
	def index
		@layer_names = ['conv2d', 'average_pooling2d', 'conv2d_1', 'average_pooling2d_1', 'flatten', 'dense', 'dense_1', 'dense_2']
	end

	def mutation_testing
		
	end
end