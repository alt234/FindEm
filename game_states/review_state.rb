require_relative "base_state"

class ReviewState < BaseState
    def initialize(options = {})
        options[:show_letters] = true
        
        super(options)
    
		#review_time = 2250;
		review_time = 1000 + 500 * @level
        Block.all.each do |block|
            during(review_time) {}.then {
				block.text.destroy!
				block.flipping = true
            }
        end
    end

    def update
        super

        all_hidden = true         
        Block.all.each do |block|
            if block.is_flipped?
                all_hidden = false
                break
            end
        end

        if all_hidden 
            puts "hidden"
            
            #push_game_state(PlayState.new(:level => @level, :rows => @rows, :columns => @columns))
        end
    end
end
