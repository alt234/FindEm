$game_started = false

class PlayState < Chingu::GameState
    traits :timer
    def initialize(options = {})
        super

        self.input = [
            :released_left_mouse_button => :released_left_mouse_button, 
            :s => :start_turn,
            :e => :end_turn
        ]

        @level = options[:level]
        @rows = options[:rows]
        @columns = options[:columns]
        
        for i in 1..@rows
            for j in 1..@columns
                xPos = j*90
                yPos = i*90
                margin = 20

                Block.create(:x => xPos+margin, :y => yPos+margin)
            end
        end

        #ResetButton.create(:x => 600, :y => 100)

        Block.all.each do |block|
            during(3000) {}.then {
                block.text.destroy
                block.flip = true
            }
        end
    end

    def released_left_mouse_button
        if @first_block == nil
            Block.all.each do |block|
                if block.is_flipped?
                    @first_block = block
                end
            end
        end
    end

    def start_turn
        push_game_state(PlayState.new(:level => @level+1, :rows => @rows+1, :columns => @columns+1))
    end

    def end_turn
        Block.all.each do |block|
            unless block.is_flipped?
                block.flip = true
            end

            if block.text.text == @first_block.text.text
                block.text.color = Color::BLUE
            else
                block.text.color = Color::RED
            end
        end
    end

    def finalize
        $game_started = false
        @first_block = nil
    end
end 
