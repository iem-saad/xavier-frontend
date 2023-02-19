class Form
  attr_accessor :name, :email, :subject, :message

  def initialize(form_params)
    @name = form_params["name"]
    @email = form_params["email"]
    @subject = form_params["subject"]
    @message = form_params["message"]
  end
end
