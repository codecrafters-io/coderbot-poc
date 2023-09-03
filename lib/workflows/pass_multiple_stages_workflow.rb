class Workflows::PassMultipleStagesWorkflow < Workflows::BaseWorkflow
  attr_accessor :course
  attr_accessor :stages
  attr_accessor :local_repository

  def initialize(course:, stages:, local_repository:)
    super()

    @course = course
    @stages = stages
    @local_repository = local_repository
  end

  def run
    stages.sort_by(&:position).each do |stage|
      pass_stage_workflow = Workflows::PassStageWorkflow.new(
        course: course,
        stage: stage,
        local_repository: local_repository
      )

      pass_stage_workflow.run
      steps.push(*pass_stage_workflow.steps)

      if pass_stage_workflow.failure?
        self.error_message = "Failed to pass stage #{stage.position}"
        break
      end

      commit_fix_step = Steps::CommitFixStep.new(
        course: course,
        stage: stage,
        local_repository: local_repository
      )
      commit_fix_step.perform
      commit_fix_step.print_logs_for_console

      steps << commit_fix_step
    end
  end
end
