require "bundler"
Bundler.require

require "active_support/all"
require "active_model"

# Autoload all files in ./lib
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
loader.push_dir("#{__dir__}/models")
loader.push_dir("#{__dir__}/prompts")
loader.setup
