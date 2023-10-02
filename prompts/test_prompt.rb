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

      The description of the course is below:

      --- DESCRIPTION START ---

      #{context.course.description_markdown}

      --- DESCRIPTION END ---

      The course has multiple stages, and the current stage is "#{context.stage.name}". The instructions for this stage are below:

      --- INSTRUCTIONS START ---

      #{context.stage.description_markdown_template}

      --- INSTRUCTIONS END ---

      The user is asking you to help them edit their code to pass this stage. The user's code is listed below delimited by triple backticks:

      ```#{context.language.syntax_highlighting_identifier}
      #{context.original_code}
      ```

      When they submitted their code, they saw the following error delimited by triple backticks below:

      ```
      #{context.test_runner_output.compilation_failed? ? context.test_runner_output.raw_output : context.test_runner_output.last_stage_logs_without_colors}
      ```

      I'm sure the test suite is correct, so there is definitely a bug in the user's code. The bug might not be obvious, so you might need to read the user's code carefully to find it.

      Your goal is to fix the user's code so that it passes the stage.

      First, think through what the bug might be. Then, come up with a plan to fix the bug. Once you have a plan, implement it by editing the user's code. Print the FULL contents of the
      edited file delimited by triple backticks.

      Here are some rules to follow:

      * Try to keep your changes minimal, but ensure the solution is complete.
      * Add comments to explain your changes, and don't remove existing comments unless they're incorrect or outdated.
      * You can remove debug print statements if you think they're unnecessary to pass the stage.
      * If you see obvious mistakes, fix them. The user is a beginner, so their code might contain mistakes that you wouldn't typically make.
      * Try to simplify code where possible, don't overcomplicate things. If a block of code looks too convoluted, it's probably wrong and needs to be redone.
      * Write production quality code that you think would be acceptable in a real world codebase. Don't write code that you think is hacky and only passes the current stage, unless the stage instructions mention otherwise.
      * Be wary of code duplication, you might be able to solve the problem better by using recursion or re-using another function.
      * IMPORTANT: Print the FULL contents of the edited file delimited by triple backticks. Don't print partial contents of the file.
    PROMPT
  end
end
