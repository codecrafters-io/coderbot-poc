class TestPrompt
  include Interactor

  def call
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"], request_timeout: 240)

    raw_response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {role: "system", content: system_message(context.solution, context.chunk)},
          {role: "user", content: user_message(context.solution, context.chunk)}
        ],
        temperature: 0
      }
    )

    context.result = raw_response.dig("choices", 0, "message", "content")
  end

  protected

  def format_diff(diff)
    diff.lines.each_with_index.map { |line, index| "#{index + 1}: #{line}" }.join
  end

  def system_message(solution, chunk)
    <<~PROMPT
      You are an assistant to a coding tutor. They're teaching a hands-on course called "#{solution.course_stage.course.name}".

      The markdown description of the course is available in markdown delimited by triple backticks below:

      ```
      #{solution.course_stage.course.description_markdown}
      ```

      The course has multiple modules, and the current module is "#{solution.course_stage.name}".

      The instructions for this module are available in markdown delimited by triple backticks below:

      ```
      #{solution.course_stage.description_markdown_for_repository(solution.repository)}
      ```

      The user is asking you to help them explain part of solution in #{solution.language.name} to a student.

      Break the solution down into multiple chunks, and explain each chunk separately. Only explain chunks where
      lines were added/removed, don't explain lines that haven't changed. When multiple changed lines are present
      next to each other, explain them together, not one by one. Don't mention line numbers in your explanations.

      Be friendly, and don't sound overconfident. Assume that the student isn't very familiar with #{solution.language.name}.

      Be concise. Don't prefix your answer with "Sure!" or "Okay!" and don't say things like "I'll explain this solution step by
      step". Just skip to the explanation directly.

      Don't mention the course name or the module name.
    PROMPT
  end

  def user_message(solution, chunk)
    changed_file = solution.changed_file(chunk["filename"])
    line_description = chunk["start_line"].eql?(chunk["end_line"]) ? "line #{chunk["start_line"]}" : "lines #{chunk["start_line"]}-#{chunk["end_line"]}"

    <<~PROMPT
      Here's are the diffs in the solution I'm looking at (there are #{solution.changed_files.count} files with changes):

      The diff for file `#{changed_file["filename"]}` is delimited by triple backticks below: \n\n```\n#{format_diff(changed_file["diff"])}\n```

      Explain #{line_description} of diff for file #{chunk["filename"]}. Limit your response to 150 words, summarize the
      changes if needed to fit within 150 words. Don't mention the filename in your response.

      IMPORTANT: Do NOT mention line numbers in your response. Include code blocks if your need to refer to specific parts of the diff.
      IMPORTANT: Only explain #{line_description}, don't explain other parts of the diff.

      Format your reponse as markdown.
    PROMPT
  end
end