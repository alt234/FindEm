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

        update
    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            @spin = true
            @flipped = true
            
            unless $game_started
                $game_started = true
                @first_letter = @letter
            end
        end
    end

    def first_letter
        @first_letter
    end

    def letter
        @letter
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

    def text
        @text
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
