class PrefixedLineWriter
  def initialize(prefix, target)
    @prefix = prefix
    @target = target
    @last_char = "\n"
  end

  def write(msg)
    bytes_written = 0
    msg.to_s.chars.each do |char|
      @target.write(@prefix) if @last_char == "\n"
      bytes_written += @target.write(char)
      @last_char = char
    end
    bytes_written
  end

  def close
  end
end
