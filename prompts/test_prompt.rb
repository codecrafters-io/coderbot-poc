class TestPrompt
  include Interactor

  def call
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"], request_timeout: 240)

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
      import json
      import sys

      # import bencodepy - available if you need it!
      # import requests - available if you need it!

      # Examples:
      #
      # - decode_bencode("5:hello") -> "hello"
      # - decode_bencode("10:hello12345") -> "hello12345"
      def decode_bencode(bencoded_value):
          if chr(bencoded_value[0]).isdigit():
              length = int(bencoded_value.split(b":")[0])
              return bencoded_value.split(b":")[1][:length]
          else:
              raise NotImplementedError("Only strings are supported at the moment")


      def main():
          command = sys.argv[1]

          # You can use print statements as follows for debugging, they'll be visible when running tests.
          print("Logs from your program will appear here!")

          if command == "decode":
              bencoded_value = sys.argv[2].encode()

              # json.dumps() can't handle bytes, but bencoded "strings" need to be
              # bytestrings since they might contain non utf-8 characters.
              #
              # Let's convert them to strings for printing to the console.
              def bytes_to_str(data):
                  if isinstance(data, bytes):
                      return data.decode()

                  raise TypeError(f"Type not serializable: {type(data)}")

              # Uncomment this block to pass the first stage
              # print(json.dumps(decode_bencode(bencoded_value), default=bytes_to_str))
          else:
              raise NotImplementedError(f"Unknown command {command}")


      if __name__ == "__main__":
          main()
      ```

      Fix the user's code so that it passes the stage.
    PROMPT
  end
end
