class Console < BaseModule
    def initialize(*args)
        super

        @userInput = ""
        @lastUserInput = @userInput
        @commands = []
        @efmStatus = {
            enabled: false,
            commands: ["scanStorages", "getStorages", "findStorage", "createStorage", "deleteStorage"],
            currentPath: [],
            currentStorage: []
        }

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

        if(@efmStatus[:enabled])
            command = ""
            args = []
            arg = ""

            isCommand = true

            if(@userInput == "efm")
                runCommand("efm")
                return
            end

            (0..@userInput.length - 1).each do |i|
                if(@userInput[i] == " " || @userInput[i] == nil)
                    if(isCommand)
                        isCommand = false
                    else
                        args.push(arg)
                        arg = ""
                    end
                    next
                end
                if(isCommand)
                    command += @userInput[i]
                    next
                end
                arg += @userInput[i]
            end

            @core.say(self, command + ";" + args.to_s)

            if(@efmStatus[:commands].include?(command))
                efm = @core.getModule("efm")
                begin
                    @core.say(self, efm.runMethod(command, args))
                rescue => exception
                    @core.outputWarning(self, "Command error", exception.to_s)
                end
            else
                @core.say(self, "Uknown EFM command: ;" + command + ";")
            end
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