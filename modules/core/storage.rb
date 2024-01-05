class Storage
    def initialize(name)
        if(!File.exists?("storages/" + name))
            Dir.mkdir("storages/" + name)
        end

        @storageInfo = {
            storageDir: File.path("storages/" + name),
            files: []
        }

        self.scanFiles()

    end

    def scanFiles()
        @storageInfo[:files] = []

        Dir.each_child(@storageInfo[:storageDir]) do
            |file|

            @storageInfo[:files].push(VFile.new(@storageInfo[:storageDir] + "/" + file))
        end
    end

# get functions

    def getFiles()
        return @storageInfo[:files]
    end

    def getName()
        return @storageInfo[:storageDir]
    end

# set functions

    def setFile(fileId, newFile)
        if(fileId > @storageInfo[:files].length - 1 || newFile.class != "VFile")
            return -1
        end

        @storageInfo[:files][fileId] = newFile

        return 0
    end

# add functions
    def addFile(filePath, fileName, fileContent)
        if(File.exists?(@storageInfo[:storageDir] + "/" + fileName))
            return -1
        end
        newFile = File.new(@storageInfo[:storageDir] + "/" + fileName, "w")

        path = ""

        filePath.each do
            |folder|
        
            path += "/" + folder
        end

        File.write(@storageInfo[:storageDir] + "/" + fileName ,path + ";" + fileName.to_s + ";" + "\n" + fileContent.to_s)

        @storageInfo[:files].push(VFile.new(newFile))
    end
# remove functions

    def removeFile(filePath, fileName)
        noFile = true
        self.getFiles.each do |file|
            if(file.getName == fileName)
                noFile = false
                break
            end
        end

        if(noFile)
            return -1
        end

        self.getFiles.each do |file|
            if(file.getName == fileName && file.getPath == filePath)
                File.delete(@storageInfo[:storageDir] + "/" + fileName)
                break
            end
        end

    end
# ======
end