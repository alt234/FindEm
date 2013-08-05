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
        
        rows = 5
        columns = 5

        for i in 1..rows
            for j in 1..columns
                xPos = j * 90
                yPos = i * 90
                margin = 20

                block = Block.create(:x => xPos+margin, :y => yPos+margin) 
        
                #during(3000) { @spin = false }.then {
                #    block.is_spinning = true
                #    block.game_started = true
                #    block.delete_text
                #} 
            end
        end

        ResetButton.create(:x => 600, :y => 100)
    end

    def draw
        super

        @cursor.draw(self.mouse_x, self.mouse_y, 100)
    end

    def needs_cursor?
        false
    end
end

class ResetButton < Chingu::GameObject
    def initialize(options = {})
        super

        self.input = [:released_left_mouse_button]
    
        @animation = Chingu::Animation.new(:file => "media/sheet_25x30.bmp")
        @animation.frame_names = { :spin => 0..4 }
        @image = @animation.first

    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            Block.all.each { |item| 
                unless item.is_flipped
                    item.is_spinning = true
                end 
            }
        end
    end
end

$game_started = false

class Block < Chingu::GameObject
    traits :timer
    
    def initialize(options = {})
        super

        self.input = [:released_left_mouse_button]

        @animation = Chingu::Animation.new(:file => "media/sheet_25x30.bmp")
        @animation.frame_names = { :spin => 0..4 }
        @image = @animation.first
        @flipped = false
        @spin = false

        @letter = ["A", "B", "C", "D"].sample

        @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4 + 4, :y => self.y - self.height/4 + 4, :color => Color::WHITE, :zorder => 1000)
        @text.factor_x = 1
        @text.factor_y = 1

        during(3000) { @spin = false }.then { 
            @text.destroy
            @spin = true 
            #$game_started = true
        }

        update
    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            @spin = true
            @flipped = true
            $game_started = true
        end
    end

    def is_flipped=(flipping)
        @flipped = flipping
    end

    def is_flipped 
        @flipped
    end

    def is_spinning=(spinning)
        @spin = spinning
    end

    def delete_text
        @text.destroy
    end

    def update
        if @spin
            @image = @animation[:spin].next
        end
        
        if @image == @animation.last
            @spin = false
            @image = @animation.first
            @animation[:spin].reset
            
            if $game_started
                @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4 + 4, :y => self.y - self.height/4 + 4, :color => Color::WHITE)
                @text.factor_x = 1
                @text.factor_y = 1
            end
        end
    end

    def all
        ObjectSpace.each_object(self).entries
    end
end

Game.new.show
