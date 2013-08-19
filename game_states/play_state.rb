require './game_states/win_state.rb'

class PlayState < BaseState 
  def initialize(options = {})
    super(options)

    #puts "GameState: Play"
    puts "Level: #{ @level }"

    $game_started = true

    self.input = [
      :s => :start_turn,
      :e => :end_turn
    ]
  end

  def update
    super

    if @first_block.nil?
      Block.all.each do |block|
        if block.is_flipped?
          @first_block = block
          #puts "First block: #{ @first_block.text.text }"
        end
      end
    end

    unless @unflipped_blocks.nil?
      @unflipped_blocks.each do |block|
        if block.is_flipped? && block.text.text == @first_block.text.text
          block.text.color = Color::YELLOW
          @missed_blocks += 1
          @unflipped_blocks.delete(block)
        end
      end
    end
  end

  def start_turn 
    level = @level+1
    rows = @rows
    columns = @columns

    if level % 2 == 0 then columns += 1 else rows += 1 end	

    pop_game_state()

    if level <= 10
      push_game_state(ReviewState.new(:level => level, :rows => rows, :columns => columns))
    else
      push_game_state(WinState.new)
    end
  end

  def finalize
    @first_block = nil
    $game_started = false
    Block.all.each { |block| block.destroy! }
  end

  def end_turn
    return if @first_block.nil? || @turn_ended

    @correct_blocks = 0
    @incorrect_blocks = 0
    @missed_blocks = 0

    @unflipped_blocks = []
    Block.all.each do |block|
      if !block.is_flipped?
        @unflipped_blocks << block
        block.flipping = true
        if block.letter == @first_block.letter 
          @missed_blocks += 1 
        end
      else
        if block.text.text == @first_block.text.text
          block.text.color = Color::BLUE
          @correct_blocks += 1
        else
          block.text.color = Color::RED
          @incorrect_blocks += 1
        end
      end
    end

    Text.create("Correct: #{@correct_blocks}", :size => 40, :factor_x => 1, :factor_y => 1, :x => 800, :y => 10, :align => :right)
    Text.create("Incorrect: #{@incorrect_blocks}", :size => 40, :factor_x => 1, :factor_y => 1, :x => 800, :y => 50, :align => :right)
    Text.create("Missed: #{@missed_blocks}", :size => 40, :factor_x => 1, :factor_y => 1, :x => 800, :y => 90, :align => :right) 
  
    @turn_ended = true
  end
end
