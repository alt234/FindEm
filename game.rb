require 'rubygems'
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require './game_objects/block.rb'
require './game_objects/reset_button.rb'

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
