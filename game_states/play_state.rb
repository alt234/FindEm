class PlayState < Chingu::GameState
    def initialize(options = {})
        super

        rows = 5
        columns = 5

        for i in 1..rows
            for j in 1..columns
                xPos = j*90
                yPos = i*90
                margin = 20

                block = Block.create(:x => xPos+margin, :y => yPos+margin)
            end
        end

        ResetButton.create(:x => 600, :y => 100)
    end
end 
