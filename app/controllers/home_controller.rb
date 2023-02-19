class HomeController < ApplicationController
	def index; end

	def submit_form
    @form = Form.new(form_params)
    ContactFormMailer.submit_contact_form(@form).deliver
    redirect_to root_path, notice: "Successfully Submitted Response."
  end

  private def form_params
    params.require(:form).permit(:name, :email, :subject, :message)
  end
end
