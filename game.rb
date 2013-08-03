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
        
        rows = 4
        columns = 4

        for i in 1..rows
            for j in 1..columns
                xPos = j * 90
                yPos = i * 90
                margin = 100

                @block = Block.create(:x => xPos+margin, :y => yPos+margin) 
            end
        end
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
        #@spin = false

        @letter = ["A", "B", "C", "D"].sample
        
        @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4, :y => self.y - self.height/4, :color => Color::WHITE, :zorder => 1000)
        @text.factor_x = 1
        @text.factor_y = 1

        @game_started = false

        during(3000) { @spin = false }.then { 
            @text.destroy
            @spin = true 
        }

        update
    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            @spin = true
            @game_started = true
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
            
            if @game_started
                @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4, :y => self.y - self.height/4, :color => Color::WHITE)
                @text.factor_x = 1
                @text.factor_y = 1
            end
        end
    end
end

Game.new.show
