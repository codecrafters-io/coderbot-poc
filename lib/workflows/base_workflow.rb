class Workflows::BaseWorkflow
  attr_accessor :steps
  attr_accessor :error_message

  def initialize(course:, stage:, local_repository:)
    self.steps = []
  end

  def html_logs
    <<~HTML
      <html>
        <head>
        </head>
        <body>
          <div>
            #{steps.map(&:html_logs).join("\n\n")}
          </div>
        </body>
      </html>
    HTML
  end
end
