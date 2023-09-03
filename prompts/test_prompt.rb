class TestPrompt < BasePrompt
  def call
    raw_response = openai_chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {role: "system", content: system_message}
        ],
        temperature: 1
      }
    )

    context.result = raw_response.dig("choices", 0, "message", "content")
  end

  protected

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

      Here are some rules to follow:

      * Try to keep your changes minimal, but ensure the solution is complete.
      * Add comments to explain your changes, and don't remove existing comments unless they're incorrect or outdated.
      * You can remove debug print statements if you think they're unnecessary to pass the stage.
      * If you see obvious mistakes, fix them. The user is a beginner, so their code might contain mistakes that you wouldn't typically make.
      * Try to simplify code where possible, don't overcomplicate things. If a block of code looks too convoluted, it's probably wrong and needs to be redone.
      * Write production quality code that you think would be acceptable in a real world codebase. Don't write code that you think is hacky and only passes the current stage, unless the stage instructions mention otherwise.
      * Be wary of code duplication, you might be able to solve the problem better by using recursion or re-using another function.
      * Print the FULL contents of the file delimited by triple backticks. Don't print partial contents of the file.
    PROMPT
  end
end
