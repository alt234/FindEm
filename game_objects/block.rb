class Block < Chingu::GameObject
    traits :timer
    def initialize(options = {})
        super

        self.input = [:released_left_mouse_button]

        @animation = Chingu::Animation.new(:file => "media/sheet_25x30.bmp")
        @animation.frame_names = { :flip => 0..4 }
        @image = @animation.first

        @letter = ["A", "B", "C", "D"].sample

        @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4 + 4, :y => self.y - self.height/4 + 4, :color => Color::WHITE, :zorder => 1000)
        @text.factor_x = 1
        @text.factor_y = 1

        update
    end

    def released_left_mouse_button
        if $window.mouse_x >= (self.x - self.width/2) && $window.mouse_x <= (self.x + self.width/2) &&
            $window.mouse_y >= (self.y - self.height/2) && $window.mouse_y <= (self.y + self.height/2)
            @flipping = true
            @flipped = false
            
            unless $game_started
                $game_started = true
            end
        end
    end

    def update
        if @flipping
            @image = @animation[:flip].next
        end
        
        if @image == @animation.last
            @flipping = false
            @image = @animation.first
            @animation[:flip].reset
            
            if $game_started
                @text = Text.create(@letter, :size => 40, :x => self.x - self.width/4 + 4, :y => self.y - self.height/4 + 4, :color => Color::WHITE)
                @text.factor_x = 1
                @text.factor_y = 1
                @flipped = true
            end
        end
    end
    
    def is_flipped? 
        @flipped
    end

    def flipped=(flipped)
        @flipped = flipped
    end

    def flipping=(flipping)
        @flipping = flipping
    end

    def text
        @text
    end
end
