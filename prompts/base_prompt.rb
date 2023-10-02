class BasePrompt
  include Interactor

  def self.diskcache
    @diskcache ||= Diskcached.new("./cache/prompts")
  end

  def openai_chat(*args, **kwargs)
    signature = JSON.generate(args: args, kwargs: kwargs)
    signature_hash = Digest::SHA256.hexdigest(signature)

    self.class.diskcache.cache(signature_hash) do
      puts "Cache miss, calling OpenAI API with signature #{signature_hash}"

      client = OpenAI::Client.new(
        access_token: ENV["OPENAI_API_KEY"],
        uri_base: "https://oai.hconeai.com/",
        request_timeout: 240,
        extra_headers: {
          "Helicone-Auth": "Bearer #{ENV["HELICONE_API_KEY"]}",
          "Helicone-Property-Prompt": "CoderBot-#{self.class.name}",
          "helicone-stream-force-format": "true"
        }
      )

      client.chat(*args, **kwargs)
    end
  end
end
