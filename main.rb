require_relative "boot"

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == "bittorrent" }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
first_stage = stages.min_by(&:position)

original_code = <<~CODE
  import json
  import sys

  # import bencodepy - available if you need it!
  # import requests - available if you need it!

  # Examples:
  #
  # - decode_bencode(b"5:hello") -> b"hello"
  # - decode_bencode(b"10:hello12345") -> b"hello12345"
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
CODE

result = TestPrompt.call(stage: first_stage, course: course, original_code: original_code).result
puts result
extracted_code = result.scan(/```python\n(.*?)```/m).join("\n")

puts "Diff:"
puts ""
puts ""

Diffy::Diff.default_format = :color
puts Diffy::Diff.new(original_code, extracted_code, context: 2)
