$game_started = false

class PlayState < Chingu::GameState
    traits :timer
    def initialize(options = {})
        super

        self.input = [:release_left_mouse_button, :e => :end_turn]

        @first_block_flipped = false

        rows = 5
        columns = 5
        
        for i in 1..rows
            for j in 1..columns
                xPos = j*90
                yPos = i*90
                margin = 20

                Block.create(:x => xPos+margin, :y => yPos+margin)
            end
        end

        #ResetButton.create(:x => 600, :y => 100)

        Block.all.each do |block|
            during(3000) {}.then {
                block.delete_text
                block.is_spinning = true
            }
        end
    end

    def released_left_mouse_button

    end

    def end_turn
        Block.all.each do |block|
            unless block.is_flipped
                block.is_spinning = true

            end
        end
    end
end 
