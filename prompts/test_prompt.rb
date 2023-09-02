class TestPrompt
  include Interactor

  def call
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"], request_timeout: 240)
    puts system_message

    raw_response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {role: "system", content: system_message}
        ],
        temperature: 0
      }
    )

    context.result = raw_response.dig("choices", 0, "message", "content")
  end

  protected

  # def format_diff(diff)
  #   diff.lines.each_with_index.map { |line, index| "#{index + 1}: #{line}" }.join
  # end

  def system_message
    <<~PROMPT
      You are a brilliant and meticulous engineer assigned to write code to pass stage #{context.stage.position} of the "#{context.course.name}" programming course.

      The description of the course is available in markdown delimited by triple backticks below:

      ```
      #{context.course.description_markdown}
      ```

      The course has multiple stages, and the current stage is "#{context.stage.name}".

      The instructions for this stage are available in markdown delimited by triple backticks below:

      ```
      #{context.stage.description_markdown_template}
      ```

      The user is asking you to help them edit their code to pass this stage. The user's code is listed below delimited by triple backticks:

      ```python
      #{context.original_code}
      ```

      When they submitted their code, they saw the following error delimited by triple backticks below:

      ```
      #{context.test_runner_output.last_stage_logs}
      ```

      Fix the user's code so that it passes the stage.

      * Always prefer the least amount of changes possible, but ensure the solution is complete
    PROMPT
  end
end
