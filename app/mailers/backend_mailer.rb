class BackendMailer < ApplicationMailer
  helper MutationViewHelper

  def notify_project_status(project)
    @project = project
    @link = "#{ view_context.link_to 'View Project', project_url(project) }"
    mail(to: project.user.email,
    subject: "Progress Status For Your Project. #{project.name}",
    from: "xavier.cfd@gmail.com")
  end

  def send_evaluation_report(project, type)
    html_string = render_to_string({
      template: "projects/export_#{type}_analysis_report",
      layout: 'pdf',
      locals: { :@project => project }
    })
    style_tag_options = [{ url: 'https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css' }]
    pdf = Grover.new(html_string, format: 'A3').to_pdf
    file_name = "Project #{project.name} Tabular Analysis Report " + Time.now.strftime('%v').to_s + ".pdf"
    @project = project
    attachments[file_name] = pdf
    @link = "#{ view_context.link_to 'View Project', project_url(project) }"
    
    mail(to: project.user.email,
    subject: "Your #{type} Report for #{project.name} is Ready, Thanks for waiting.",
    from: "xavier.cfd@gmail.com")
  end
end
