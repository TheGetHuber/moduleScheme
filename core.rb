class Core
    def initialize()

        @miscModules = [] # misc modules are stored in here
        @mainLoopFunctions = [] # functions that must be executed in main loop

        self.say self, "Initializing Core..."

        self.loadModules

        @efm = EFM.new(__dir__+"/core/efm.rb")
        @efm.initCore(self)
        @user = User.new(__dir__+"/core/user.rb")
        @user.initCore(self)

        self.checkModules

        if(@miscModules != [])
            for i in @miscModules do
                i.initCore(self)
            end
        end

        @miscModules.each do
            |miscModule|

            self.say self, miscModule.class
        end

        self.say self, "Ready!"

    end

    def say(entity, message)
        puts "[ " + entity.class.to_s + " ]: " + message.to_s
    end



    def outputError(responsible, reason, details = nil)
        puts "! -- ERROR at " + responsible.to_s
        puts "! -- " + reason.to_s
        puts "! -- Details: " + details.to_s
        abort

    end

    def outputWarning(responsible, reason, details = nil)
        puts "-- WARNING at " + responsible.to_s
        puts "-- " + reason.to_s
        puts "-- Details: " + details.to_s
    end

    def shutdown(initiator)
        self.say(self, "Shutting down by " + initiator.class.to_s + "...")
        exit 
    end



    def loadModules()                                           # we dont have EFM on that stage
        Dir[File.join(__dir__, "modules/core", "*.rb")].each{   # so Core has it's own part of it
            |file| require file                                 # made only for loading modules
        }

        Dir.each_child(Dir.pwd + "/modules/custom"){
            |moduleDir|

            moduleDirPath = Dir.pwd + "/modules/custom" + "/" + moduleDir

            if !File::directory?(moduleDirPath)
                next
            end
        
            Dir.each_child(moduleDirPath){
                |manifest|
        
                if(manifest != "manifest.json")
                    next
                end
        
                file = File.new(moduleDirPath + "/" + manifest)
                raw = JSON.parse(file.read)
        
                require moduleDirPath + "/" + raw["mainScriptFile"]
                
                @miscModules.push(eval(raw["className"] + ".new(\"" + moduleDirPath + "\")"))

            }
        }
    end

    def checkModules()
        begin
            @efm.ping
            @user.ping

            @miscModules.each do |miscModule|
               dependencies = miscModule.getVar("parsedManifest")
               puts "SHIT"
               puts dependencies 
            end

            @miscModules.each do |miscModule|
                begin
                    miscModule.ping
                rescue => exception
                    outputError(self, "Misc module" + miscModule.to_s + " isnt ponged! Check failed", exception)
                end
            end
        rescue => exception
            outputError(self, "Some module isn't ponged! Check failed", exception)
        end
    end

    def getModule(name = nil)
        if(name == nil)
            self.outputError(self, "No argument was given", "No argument was given for getModule!")
        end
        
        if(name == "efm")
            return @efm
        elsif(name == "user")
            return @user
        elsif(name == "**")
            return @miscModules
        else
            @miscModules.each do
                |miscModule|
                if(name == miscModule.class.to_s)
                    return miscModule
                end
            end
        end
    end

    def runCommand(command)
        begin
            eval("self." + command)
        rescue => e
            outputWarning(self, "Unknown excpetion!", "Tried to run " + command + " but got " +e.to_s)
        end
        
    end



    def addMainLoopFunc(moduleName, func)
        if(!@mainLoopFunctions.include?(moduleName))
            moduleHash = {:name => moduleName, :functions => []}
            @mainLoopFunctions.push(moduleHash)
        end

        @mainLoopFunctions.each do
            |moduleHash|
            if(moduleHash[:name] == moduleName)
                moduleHash[:functions].push func
            end
        end
    end

    def removeMainLoopFunc(moduleName, func)
        if(@mainLoopFunctions[moduleName] == nil)
            self.outputError(self, "Main loop error!", "Tried to delete " + func.to_s + " but " + moduleName.to_s + " not even described!")
        end
        if(!@mainLoopFunctions[moduleName]["functions"].include?(func))
            self.outputError(self, "Main loop error!", "Tried to delete " + func.to_s + " but " + func.to_s + " not even described!")
        end
        
        (0..@mainLoopFunctions[moduleName]["functions"].length).each do [i]
            if(@mainLoopFunctions[moduleName]["functions"].at(i) == func)
                @mainLoopFunctions[moduleName]["functions"].delete_at(i)
            end
        end
        
    end

    def mainLoop()
        self.say self,  "mainLoopStart"
        while(true)
            @mainLoopFunctions.each{
                |moduleHash|
                moduleHash[:functions].each do
                    |func|
                    @miscModules.each do 
                        |miscModule|
                        if(miscModule.class.to_s == moduleHash[:name])
                            miscModule.runMethod(func.to_s)
                        end
                    end
                end
            }
        end
    end

end
