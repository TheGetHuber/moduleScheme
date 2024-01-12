class EFM < BaseModule
    def initialize(*args)
        super

        require "./modules/core/storage.rb"
        require "./modules/core/vfile.rb"

        @storages = []

    end

# storages

    def scanStorages()
        @storages = []

        Dir.each_child("./storages") do |storage|
            @storages.push(Storage.new(storage))
        end
    end

    def getStorages()
        return @storages
    end

    def findStorage(storageName)
        @storages.each do |storage|
            if(storage.getName == storageName)
                return true
            end
        end
        return false
    end

    def createStorage(storageName)
        if(!self.findStorage(storageName))
            @storages.push(Storage.new(storageName))
            return 1
        end
        return -1
    end

    def deleteStorage(storageName)
        if(!self.findStorage(storageName))
            return -1
        end

        if(!Dir.empty?("./storages/" + storageName))
            Dir.each_child do |file|
                File.delete("./storages/" + storageName + "/" + file)
            end
        end

        Dir.rmdir("./storages/" + storageName)
    end
# files

    def findFile(storageName, filePath, fileName)
        storage = @storages[storageName]

        puts storage
    end

    def createFile(storageName, filePath, fileName, fileContent)
        return
    end
end 