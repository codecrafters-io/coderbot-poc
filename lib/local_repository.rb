class LocalRepository
  attr_accessor :repository_dir

  def initialize(repository_dir)
    @repository_dir = repository_dir
  end

  def code_file_path
    files = Dir.glob(File.join(@repository_dir, "**", "*.#{language.code_file_extension}"))

    if files.length > 1
      raise "Found multiple code files: #{files.join(", ")}"
    end

    files.first
  end

  def language
    Language.find_by_language_pack!(language_pack)
  end

  def language_pack
    YAML.load_file(File.join(repository_dir, "codecrafters.yml"))["language_pack"]
  end
end
