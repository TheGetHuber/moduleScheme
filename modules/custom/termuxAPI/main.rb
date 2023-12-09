class TermuxAPI < BaseModule
    def initialize(*args)
        super
    end
  
    def syscall(command)
        output = [] #0-stdin;1-stdout;2-stderr;3-wait_thr
        output[0],output[1],output[2],output[3] = Open3.popen3(command)
        return output
    end
  
    def api(state)
        state ? self.syscall("termux-api-start") : self.syscall("termux-api-stop")
    end
  
    def notification(title, content, id = nil, alertOnce = true, button1 = nil, button1Act = nil, button2 = nil, button2Act = nil, button3 = nil, button3Act = nil)
        command = "termux-notification -t \"#{title}\" -c \"#{content}\""
  
        id != nil ? command += " --id \"#{id}\"" : false
        alertOnce == true ? command += " --alert-once" : false
        button1 != nil ? command += " --button1 \"#{button1}\"" : false
        button1Act != nil ? command += " --button1-action \"#{button1Act}\"" : false
        button2 != nil ? command += " --button2 \"#{button2}\"" : false
        button2Act != nil ? command += " --button2-action \"#{button2Act}\"" : false
        button3 != nil ? command += " --button3 \"#{button3}\"" : false
        button3Act != nil ? command += " --button3-action \"#{button3Act}\"" : false
  
        self.syscall(command)
    end
  
    def pinnedNotify(title, content, id)
       self.syscall("termux-notification --ongoing -t #{title} -c #{content} --id #{id}")
    end
  
    def deleteNotify(id)
        self.syscall("termux-notification-remove #{id}")
    end
  
    def listNotifies()
        raw = self.syscall("termux-notification-list")[1].gets(nil)
        return JSON.parse(raw)
    end
  
    def findNotifyBy(type, value)
        notifies = self.listNotifies
        id = 0
        begin
        (0..notifies.length).each do |i|
            if(notifies[i][type] == value)
                id = i
                return id
            end
        end
        rescue NoMethodError
            puts "Coudnt found the notififcation. Maybe type or value were wrong"
            return 1
        end
    end
  
  
    def finger()
        return self.syscall("termux-fingerprint")
    end
  
    def brightness(amount)
        if(amount > 255)
            puts "WARN: cant make the brightness to be more than 255. setted as 255"
            self.syscall("termux-brightness 255")
            return 0
        end
        if(amount < 1)
            puts "WARN: cant make the brightness to be less than 1. setted as 1"
            self.syscall("termux-brightness 1")
            return 0
        end
        self.syscall("termux-brightness #{amount}")
    end
  
    def batteryStatus(type = nil)
        if(type == nil)
            return JSON.parse(self.syscall("termux-battery-status")[1].gets(nil))
        end
        begin
            battery = JSON.parse(self.syscall("termux-battery-status")[1].gets(nil))
            return battery[type]
        rescue NoMethodError
            puts "ERROR: Wrong type was given"
            return 0
        end
    end
  
    def dialog(type)
        types = ["confirm", "checkbox", "counter", "date", "radio", "spinner", "speech", "text", "time"]
        if(types.include?(type) == false)
            puts "ERROR: Wrong dialog's type was given"
            return 1
        end
        command = "termux-dialog #{type}"
        return JSON.parse( self.syscall(command)[1].gets(nil) )
    end
  
    def toast(text, color_bg = "black", color_font = "white", pos = "bottom", long = false)
        command = "termux-toast -b \"#{color_bg}\" -c \"#{color_font}\" -g #{pos}"
        long ? command += " -s " : false
        self.syscall(command)
        command += " \"#{text}\""
    end
  
    def contactList()
        raw = self.syscall("termux-contact-list")[1].gets(nil)
        return JSON.parse(raw)
    end
  
    def vibrate(duraction = 1000, force = false)
        command = "termux-vibrate -d #{duraction}"
        force ? command += " -f" : false
        self.syscall(command)
    end
  
    def vibratePattern(pattern, globalDelay = 0)
        if(globalDelay == 0)
        
        end
        pattern.length % 2 == 1 ? true : pattern.push(nil)
        (0..pattern.length).each do |i|
            if(pattern[i*2] == nil)
                break
            end
            if(pattern[i*2+1] == nil)
                break
            end
            self.vibrate(pattern[i*2])
            sleep(pattern[i*2+1] + (pattern[i*2] / 1000))
        end
    end
  
    def wake(state)
        command = "termux-wake-"
        state ? command += "lock" : command += "unlock"
        self.syscall(command)
    end
  
    def sensorList()
        raw = self.syscall("termux-sensor -l")[1].gets(nil)
        return JSON.parse(raw)
    end
  
    def sensorListen(sensor) # listens to a sensor FOR 1 TIME! USE IT IN A LOOP FOR MULTIPLY OF ANSWERS
        raw = self.syscall("termux-sensor -s \"#{sensor}\" -n 1")[1].gets(nil)
        return JSON.parse(raw)
    end
  
    def info()
        return self.syscall("termux-info")[1].gets(nil)
    end
  
    def teleDeviceInfo()
        return JSON.parse(self.syscall("termux-telephony-deviceinfo")[1].gets(nil))
    end
  
    def volume(stream = nil, volume = nil)
        if(stream == nil or volume == nil)
            return JSON.parse(self.syscall("termux-volume")[1].gets(nil))
        end
        self.syscall("termux-volume \"#{stream}\" #{volume}")
    end
  end 
  