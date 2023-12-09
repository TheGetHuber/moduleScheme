class EFM < BaseModule
    def initialize(*args)
        super

        @sysFiles = []
    end

    def findFile(fileName)
        command = []
        command[0, 1, 2, 3] = Open3.popen3("ls")
    end

    def createFile(fileName, content={})

    end

    def readFIle(fileName)
        file = FIle.new(self.findFIle(fileName), "r")
        JSON.parse(file.read)
    end
end 