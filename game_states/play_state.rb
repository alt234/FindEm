$game_started = false

class PlayState < BaseState 
  def initialize(options = {})
    options[:show_letters] = false

    super(options)

    #$game_started = true

    self.input = [
      :s => :start_turn,
      :e => :end_turn
    ]

    #ResetButton.create(:x => 600, :y => 100)
  end

  def update
    super

    if @first_block.nil?
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
    @first_block = nil
    Block.all.each { |block| block.destroy! }

    level = @level+1
    rows = @rows
    columns = @columns

    if level % 2 == 0 then columns += 1 else rows += 1 end	

    push_game_state(ReviewState.new(:level => level, :rows => rows, :columns => columns))
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
