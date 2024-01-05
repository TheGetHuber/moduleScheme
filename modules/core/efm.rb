class EFM < BaseModule
    def initialize(*args)
        super

        require "./modules/core/storage.rb"
        require "./modules/core/vfile.rb"

        @storages = []

    end

    def scanStorages()
        @storages = []

        Dir.each_child("./storage") do |storage|
            @storages.push(Storage.new(storage))
        end
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

    

end 