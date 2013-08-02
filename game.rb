require 'rubygems'
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

class Game < Chingu::Window
    def initialize
        super
        retrofy
        @factor = 3
        @input = { :escape => :exit }
        #@cursor = false
        @cursor = Gosu::Image.new(self, 'media/mouse.png')
        @block = Block.create(:x => $window.width/2, :y => $window.height/2)
    end

    def draw
        super
        @cursor.draw(self.mouse_x, self.mouse_y, 100)
    end

    def needs_cursor?
        false
    end
end

class Block < Chingu::GameObject
    traits :timer
    
    def initialize(options = {})
        super

        self.input = [:released_left_mouse_button]

        @animation = Chingu::Animation.new(:file => "media/sheet_25x30.bmp")
        @animation.frame_names = { :spin => 0..4 }
        @image = @animation.first
        @spin = false
        update
    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            @spin = true
        end
    end

    def update
        if @spin
            @image = @animation[:spin].next
        end
        
        if @image == @animation.last
            @spin = false
            @image = @animation.first
            @animation[:spin].reset
        end
    end
end

Game.new.show
