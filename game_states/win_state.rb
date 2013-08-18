require './game_states/review_state.rb'

class WinState < Chingu::GameState
  def initialize(options = {})
    super

    self.input = [:e => :new_game]

    Text.create("You Win!", :size => 40, :x => 10, :y => 10)
  end

  def new_game
    pop_game_state(:setup => false, :finalize => false)
    push_game_state(ReviewState.new(:level => 1, :rows => 2, :columns => 2))   
  end
end
