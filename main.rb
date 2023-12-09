#require './user.rb'
#require "./tasker.rb"
#require "./moduleBase.rb"
#require "./fileManager.rb"

require "./core.rb"

require "json"
require "open3"
require "colorize"

dayManager = Core.new()

dayManager.mainLoop()