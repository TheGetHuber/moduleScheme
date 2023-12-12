class Toolbar < BaseModule
    def initialize(*args)
        super

        @userInput
        @termux = @core.getModule("TermuxAPI")
    end

    def mainLoop()
        @termux.notification("test", "notification")
    end
end