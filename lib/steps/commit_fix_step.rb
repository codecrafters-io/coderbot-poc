class Steps::CommitFixStep
  attr_accessor :course
  attr_accessor :local_repository
  attr_accessor :stage

  attr_accessor :diff

  def initialize(course:, stage:, local_repository:)
    @course = course
    @stage = stage
    @local_repository = local_repository
  end

  def perform
    current_code = File.read(local_repository.code_file_path)
    original_code = ShellCommand.new("git -C #{local_repository.repository_dir} show HEAD:#{local_repository.relative_code_file_path}").run!.stdout
    self.diff = Diffy::Diff.new(original_code, current_code, context: 2)

    ShellCommand.new("git -C #{local_repository.repository_dir} add #{local_repository.relative_code_file_path}").run!
    ShellCommand.new("git -C #{local_repository.repository_dir} commit -a --allow-empty --message 'pass stage #{stage.position}'").run!
  end

  def html_logs
    <<~HTML
      <div>
        <h2>Commit fix (Stage ##{stage.position})</h2>

        <pre><code class="language-diff">#{diff.to_s(:text)}</code></pre>
      </div>
    HTML
  end

  def print_logs_for_console
    puts "Commit Fix (Stage ##{stage.position}):"
    puts ""
    puts diff.to_s(:color)
    puts ""
  end

  def title
    "Commit fix (Stage ##{stage.position})"
  end
end
