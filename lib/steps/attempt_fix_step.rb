class Steps::AttemptFixStep
  attr_accessor :course
  attr_accessor :local_repository
  attr_accessor :stage
  attr_accessor :test_runner_output

  attr_accessor :diff

  def initialize(course:, stage:, local_repository:, test_runner_output:)
    @course = course
    @stage = stage
    @local_repository = local_repository
    @test_runner_output = test_runner_output
  end

  def perform
    current_code = File.read(local_repository.code_file_path)

    result = TestPrompt.call(
      stage: stage,
      course: course,
      language: local_repository.language,
      original_code: current_code,
      test_runner_output: test_runner_output
    ).result

    edited_code = result.scan(/```#{local_repository.language.syntax_highlighting_identifier}\n(.*?)```/m).join("\n")

    Diffy::Diff.default_format = :color
    self.diff = Diffy::Diff.new(current_code, edited_code, context: 2)

    File.write(local_repository.code_file_path, edited_code)
  end

  def html_logs
    <<~HTML
      <div>
        <h2>Attempt fix (Stage ##{stage.position})</h2>

        <details>
          <pre><code class="language-diff">#{diff.to_s(:text)}</code></pre>
        </details>
      </div>
    HTML
  end

  def print_logs_for_console
    puts "Diff (Stage ##{stage.position}):"
    puts ""
    puts diff.to_s(:color)
    puts ""
  end

  def title
    "Attempt fix (Stage ##{stage.position})"
  end
end
