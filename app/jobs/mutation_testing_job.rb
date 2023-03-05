class MutationTestingJob < ApplicationJob
  queue_as :default

  def perform(project)
    @backend_serice ||= XavierBackendService.new
    response = @backend_serice.start_mutation_testing(project.id)
  end
end
