class LocalTestRunner
  attr_accessor :course
  attr_accessor :repository_dir

  def initialize(course, repository_dir)
    @course = course
    @repository_dir = repository_dir
  end

  def run_tests(stage)
    build_command = ShellCommand.new("docker build -t #{docker_image_tag}  -f #{dockerfile_path} #{@repository_dir}")
    build_command.run!

    tester_dir = TesterDownloader.new(course).download_if_needed

    run_command = ShellCommand.new([
      "docker run",
      "--rm",
      "--cap-add SYS_ADMIN",
      "-v '#{File.expand_path(@repository_dir)}:/app'",
      "-v '#{File.expand_path(tester_dir)}:/tester:ro'",
      "-v '#{File.expand_path("fixtures/test.sh")}:/init.sh'",
      "-e CODECRAFTERS_SUBMISSION_DIR=/app",
      "-e CODECRAFTERS_COURSE_PAGE_URL=http://test-app.codecrafters.io/url",
      "-e CODECRAFTERS_CURRENT_STAGE_SLUG=#{stage.slug}",
      "-e TESTER_DIR=/tester",
      "-w /app",
      "--memory=2g",
      "--cpus=0.5",
      "#{docker_image_tag} /init.sh"
    ].join(" "))

    run_command_result = run_command.run

    raise "Failed to run tests, got exit code #{run_command_result.exit_code}" unless [0, 1].include?(run_command_result.exit_code)

    TestRunnerOutput.new(run_command_result.stdout)
  end

  protected

  def dockerfile_path
    File.join(dockerfiles_dir, "#{language_pack}.Dockerfile")
  end

  def dockerfiles_dir
    File.join(File.dirname(__FILE__), "..", "fixtures", "courses", course.slug, "dockerfiles")
  end

  def docker_image_tag
    "coderbot-#{course.slug}-#{language_pack}"
  end

  def language_pack
    YAML.load_file(File.join(repository_dir, "codecrafters.yml"))["language_pack"]
  end

  def tester_dir
    TesterDownloader.new(course).download_if_needed
  end
end
