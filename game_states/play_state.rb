$game_started = false

class PlayState < Chingu::GameState
  traits :timer
  def initialize(options = {})
    super

    self.input = [
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

        Block.create(:x => xPos, :y => yPos)
      end
    end

    #ResetButton.create(:x => 600, :y => 100)

    review_time = 2250;
    #review_time = 1000 + 500 * @level
    Block.all.each do |block|
      during(review_time) {}.then {
        block.text.destroy!
        block.flipping = true
      }
    end
  end

  def update
    super

    if $game_started && @first_block.nil?
      Block.all.each do |block|
        if block.is_flipped?
          @first_block = block
          puts "Level: #{ @level }"
          puts "First block: #{ @first_block.text.text }"
        end
      end
    end

    unless @unflipped_blocks.nil?
      @unflipped_blocks.each do |block|
        if block.is_flipped? && block.text.text == @first_block.text.text
          block.text.color = Color::YELLOW
          @unflipped_blocks.delete(block)
        end
      end
    end
  end

  def start_turn 
    $game_started = false
    @first_block = nil
    Block.all.each do |block|
      block.destroy!
    end

    level = @level+1
    rows = @rows
    columns = @columns

    if level % 2 == 0
      columns += 1 
    else 
      rows += 1
    end	

    push_game_state(PlayState.new(:level => level, :rows => rows, :columns => columns))
  end

  def end_turn
    @unflipped_blocks = []
    Block.all.each do |block|
      unless block.is_flipped?
        @unflipped_blocks << block
        block.flipping = true
      end

      unless @first_block.nil?	
        if block.text.text == @first_block.text.text
          block.text.color = Color::BLUE
        else
          block.text.color = Color::RED
        end
      end
    end
  end
end
