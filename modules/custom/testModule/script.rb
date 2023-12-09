class TestModule < BaseModule
    def initialize(*args)
        super
        
    end

    def test()
        puts self.to_s + " is talking!"
    end

    def penis(text)
        puts text
    end
end