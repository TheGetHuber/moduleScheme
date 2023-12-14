class Toolbar < BaseModule
    def initialize(*args)
        super

        @isInitialized = false
        @termux = nil
    end

    def mainLoop()
      if(!@isInitialized)
        @termux = @core.getModule("TermuxAPI")
        isInitialized = true
      end
        puts @core
        @termux.notification("test", "notification")
    end
end
