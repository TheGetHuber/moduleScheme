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
        @termux.notification("test", "notification", 128, true, "Text", "ls")
    end
end
