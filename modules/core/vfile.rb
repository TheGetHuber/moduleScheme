class VFile
# basic functions
    def initialize(file)
        @file = File.open(file,"r+")
        @plainContent = @file.read()
        @manifest = String.new()
        @content = String.new()

        @properties = {
            path: [],
            name: String.new(),
            size: @file.size()
        }

        self.analyze()
    end

    def analyze()
        @properties[:path] = []
        @properties[:name] = String.new()
        @properties[:size] = @file.size()

        @file.pos = 0
        @manifest = @file.readline()

        @file.seek(0, :CUR)

        @content = @file.read()

        path = ""

        (0..@manifest.length).each do |i|
            if(@manifest[i] == ";")
                break
            end
            path += @manifest[i]
        end

        (path.length + 1..@manifest.length).each do |i|
            if(@manifest[i] == ";")
                break
            end
            @properties[:name] += @manifest[i]
        end

        folder = String.new()

        (1..path.length).each do |i|
            if(path[i] == "/" || path[i] == nil)
                @properties[:path].push folder
                folder = ""
                next
            end

            folder += path[i]
        end

    end

    def compile()
        @file.truncate(0)

        @file.pos = 0

        @file.write(self.getPathString + ";" + @properties[:name] + ";")
        
        @file.seek(0, :CUR)
        @file.write("\n"+@content)

        self.analyze
    end
# get functions
    def getName()
        return @properties[:name]
    end

    def getPath()
        return @properties[:path]
    end

    def getPathString()
        path = ""

        @properties[:path].each do
            |folder|
        
            path += "/" + folder
        end

        return path
    end
    
    def getSize()
        return @properties[:size]
    end

    def readContent()
        return @content
    end

# set functions

    def writeContent(text)
        @content = text
        self.compile()
    end

    def setPath(path)
        @properties[:path] = path
        self.compile
    end

    def setName(name)
        @properties[:name] = name
        self.compile
    end

# =====

end