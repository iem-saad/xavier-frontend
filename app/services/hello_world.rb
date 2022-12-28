class HelloWorld < ApplicationService
	def test
		self.class.get("/", {})
	end
end