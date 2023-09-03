# Ported from https://github.com/jmervine/diskcached & simplified
class Diskcached
  attr_reader :store

  # initialize object
  # - set #store to passed or default ('/tmp/cache')
  def initialize(store = "/tmp/cache")
    @store = store
    ensure_store_directory
  end

  def cache(key)
    cached_value = get(key)

    if cached_value
      cached_value
    else
      content = proc { yield }.call
      set(key, content)
      content
    end
  end

  def set key, value
    write_cache_file(key, Marshal.dump(value))
  end

  def get(key)
    if File.exist?(cache_file(key))
      Marshal.load(read_cache_file(key))
    end
  end

  # returns path to cache file with 'key'
  def cache_file(key)
    File.join(store, "#{key}.cache")
  end

  private

  def write_cache_file(key, content)
    f = File.open(cache_file(key), "w+")
    f.flock(File::LOCK_EX)
    f.write(content)
    f.close
    content
  end

  # reads the actual cache file
  def read_cache_file key
    f = File.open(cache_file(key), "r")
    f.flock(File::LOCK_SH)
    out = f.read
    f.close
    out
  end

  # creates #store directory if it doesn't exist
  def ensure_store_directory
    FileUtils.mkpath(store) unless File.directory?(store)
  end
end
