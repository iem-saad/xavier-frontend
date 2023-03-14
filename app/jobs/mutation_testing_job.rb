class MutationTestingJob < ApplicationJob
  queue_as :default

  def perform(project)
    @backend_serice ||= XavierBackendService.new
    response = {}
    response = @backend_serice.start_mutation_testing(project.id) if !project.completed?
    if response["detail"].present? && response["detail"].include?("Success")
      Notification.create(project: project, user: project.user, n_type: 0, text: "Successfully Processed")
      BackendMailer.notify_project_status(project).deliver_now
    end
  end
end
