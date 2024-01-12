class User < BaseModule
    def initialize(*args)
        super

        @name = ""

        @initialized = false
        self.initUser("test")

        # TODO: core modules cant interract with core, needs to he fixed
    end

    def initUser(user)
        @efm = @core.getModule("efm")

        @efm.findFile("system0", "", "")

        @initialized = true
    end

    def getData(moduleName, dataName)
        return
    end

    def writeData(moduleName, dataName, dataValue)
        return
    end

    def getAllData(moduleName)
        return
    end
end