class Console < BaseModule
    def initialize(*args)
        super

        @userInput = ""
        @lastUserInput = @userInput
        @commands = []

        Dir.each_child("./modules/custom/console/commands/") do |file|
            @commands.push(File.basename(file, ".rbcmd"))
        end

        @prefix = "$ "
        @inCore = false
    end

    def changePrefix(prefix = nil)
        if(prefix == nil)
            @core.outputError(self, "Prefix was not specified", "No prefix was specified")
        end
        puts prefix
        @preifx = prefix
    end

    def checkComand()
        if(@inCore)
            if(@userInput.strip == "exit")
                self.runCommand("exit")
                return
            end
            @core.runCommand(@userInput)
            return
        end

        command = ""
        args = []
        arg = ""
        isCommand = true

        (0..@userInput.length()-1).each do |i|
            if(@userInput[i] != " " && isCommand)
                command += @userInput[i]
                next
            else
                isCommand
            end
            if(@userInput[i] != ",")
                arg += @userInput[i]
            else
                args.push(arg)
            end
        end

        runCommand(command)
    end

    def runCommand(command)
        begin
            eval(File.open("modules/custom/console/commands/" + command.to_s + ".rbcmd").read())
        rescue
            @core.say self, "unknown command: " + command.to_s
        end
    end

    def getUserInput()
        @lastUserInput = @userInput

        print @prefix
        @userInput = gets.chomp
        checkComand()
    end
end