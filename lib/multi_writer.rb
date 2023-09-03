# Helper class to write to multiple targets at once
class MultiWriter
  def initialize(*targets)
    @targets = targets
  end

  def write(*args)
    @targets.map { |t| t.write(*args) }.first
  end

  def close
    @targets.each(&:close)
  end
end
