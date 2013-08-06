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
