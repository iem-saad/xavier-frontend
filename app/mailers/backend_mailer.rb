class BackendMailer < ApplicationMailer
  def notify_project_status(project)
    @project = project
    @link = "#{ view_context.link_to 'View Project', project_url(project) }"
    mail(to: project.user.email,
    subject: "Progress Status For Your Project. #{project.name}",
    from: "xavier.cfd@gmail.com")
  end
end
