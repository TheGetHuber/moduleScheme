class BaseModule
    def initialize(moduleDir)
        @moduleDir = moduleDir
        @manifest = nil
        @parsedManifest = nil
        @core = nil

        if(File.directory?(moduleDir))
            @manifest = File.open(@moduleDir + "/manifest.json")
        end

    end

    def initModule()

        @core.say self, "Initializing " + self.class.to_s + "..."
    end

    def getVar(variable)
        output = nil

        begin
            output = eval("@" + variable)
        rescue SyntaxError => exeption
            @core.outputError self, "Trying to call not existing variable", "Variable "+variable.to_s+" does not exsists!"
        end
    end

    def runMethod(method = nil, args = [])
        if(method == nil)
            @core.outputError(self, "No method was given", "No method was specified to be executed!")
            return -1
        end

        argsString = ""
        args.each do # TODO: args are gives straight
            |arg|    # it supposed to give them spearated with comma
            argsString += arg.to_s
        end

        eval(method.to_s+ "(" + argsString + ")")
    end

    def initCore(core)
        if(@core != nil)
            return -1
        end

        @core = core

        if(@manifest != nil)
            @parsedManifest = JSON.parse(@manifest.read)
            @parsedManifest["mainLoopFunctions"].each{ 
                |func|

                @core.addMainLoopFunc(@parsedManifest["className"], func["name"])
            }
        end 
    end

    def ping()
        return 1
    end
end
