class ContactFormMailer < ApplicationMailer
  def submit_contact_form(form)
    @form = form
    mail(to: "xavier.cfd@gmail.com",
    subject: 'You Have A Query Pending at xaiver.com',
    from: @form.email)
  end
end
