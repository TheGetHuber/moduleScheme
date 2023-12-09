class Console < BaseModule
    def initialize(*args)
        super

        @userInput = ""
        @lastUserInput = @userInput
        @commands = ["clear", "echo", "help", "exit", "test", "listModules", "enterCore"]

        @prefix = "$"
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
                self.exit()
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

        if(@commands.include?(command.to_s.strip))
            eval("self."+command.to_s)
        else
            puts "unknown command: " + command.to_s.strip
        end
    end

    def getUserInput()
        @lastUserInput = @userInput

        print @prefix + " "
        @userInput = gets.chomp
        checkComand()
    end

    def clear()
        system("clear")
    end

    def help()
        @commands.each do
            |command|
            puts command
        end
    end

    def echo(text)
        puts text
    end

    def test()
        @core.getModule("TestModule").runMethod("test")
    end

    def listModules()
        @core.getModule("**").each do 
            |miscModule|
            info = miscModule.getVar("parsedManifest")["info"]

            puts info["name"] + " - " + info["desc"] + " | Version: " + info["version"] + " ;Author: " + info["author"]
        end
    end

    def enterCore()
        @core.say self, "Entering core..."
        @prefix = "Core."
        @inCore = true
    end

    def exit()
        if(@inCore)
            @inCore = false
            @prefix = "$ "
            @core.say self, "Exiting core..."
            return 0
        end
        @core.shutdown(self)
    end
end