require 'bundler'
Bundler.require

# Autoload all files in ./lib
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
loader.setup