class MutationTestingJob < ApplicationJob
  queue_as :default

  def perform(project)
    @backend_serice ||= XavierBackendService.new
    response = {}
    response = @backend_serice.start_mutation_testing(project.id) if !project.completed?
    if response["message"].present? && response["message"].include?("Success")
      Notification.create(project: project, user: project.user, n_type: 0, text: "Successfully Processed")
      BackendMailer.notify_project_status(project).deliver_now
    end
  end
end
