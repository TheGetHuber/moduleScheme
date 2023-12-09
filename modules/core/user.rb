class User < BaseModule
    def initialize(*args)
        super

        @name = ""
        @metadata = {}
    end

    def setup(name, metadata)
        @name = name
        @metadata = metadata
    end

    def saveData(fileName)
        saveFileContent = {}
        saveFileName = "user" + @name + "saveFile.json"
    end

    def loadData(fileName)
        
    end
end