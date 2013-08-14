require_relative "base_state"

class ReviewState < BaseState
  def initialize(options = {})
    puts "GameState: Review"

    @rows = options[:rows]
    @columns = options[:columns] 

    @letters = []
    for i in 0...@rows
      current_row = []
      for j in 0...@columns
        current_row << ("A".."D").to_a.sample
      end
      @letters << current_row
    end

    options[:letters] = @letters
    options[:show_letters] = true

    super(options)

    #review_time = 2250;
    review_time = 1000 + 500 * @level
    Block.all.each do |block|
      during(review_time) {}.then do
        block.text.destroy!
        block.flipping = true
      end
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
      push_game_state(PlayState.new(:level => @level, :rows => @rows, :columns => @columns, :letters => @letters, :show_letters => false))
    end
  end
end
