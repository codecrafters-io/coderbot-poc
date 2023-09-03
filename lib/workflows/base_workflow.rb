class Workflows::BaseWorkflow
  attr_accessor :steps
  attr_accessor :error_message

  def initialize
    self.steps = []
  end

  def html_logs
    <<~HTML
      <html>
        <head>
          <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/default.min.css">
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>

          <!-- and it's easy to individually load additional languages -->
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/languages/go.min.js"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/languages/python.min.js"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/languages/diff.min.js"></script>
        </head>
        <body>
          <div>
            #{steps.map(&:html_logs).join("\n\n")}
          </div>

          <script>hljs.highlightAll();</script>
        </body>
      </html>
    HTML
  end

  def success?
    error_message.nil?
  end

  def failure?
    !success?
  end
end
