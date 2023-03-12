class BackendMailer < ApplicationMailer
  def notify_project_status(project)
    @project = project
    mail(to: project.user.email,
    subject: "Progress Status For Your Project. #{project.name}",
    from: "xavier.cfd@gmail.com")
  end
end
