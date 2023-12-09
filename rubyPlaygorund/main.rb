require "json"

modules = []

Dir.each_child(Dir.pwd){
    |moduleDir|

    if !File::directory?(moduleDir)
        next
    end

    Dir.each_child(moduleDir){
        |manifest|

        if(manifest != "manifest.json")
            next
        end

        file = File.new(Dir.pwd + "/" + moduleDir + "/" + manifest)
        raw = JSON.parse(file.read)
        puts(raw["info"]["name"] + " - " + raw["info"]["desc"])

        require "./" + moduleDir + "/" + raw["scriptFile"]

        modules.push(eval(raw["className"] + ".new"))
    }
}