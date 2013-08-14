class BaseState < Chingu::GameState 
  traits :timer

  def initialize(options = {})
    super

    @level = options[:level]
    @rows = options[:rows]
    @columns = options[:columns] 
    @letters = options[:letters]

    for i in 0...@rows
      for j in 0...@columns
        margin = 50
        xPos = j*90 + margin
        yPos = i*90 + margin

        Block.create(:x => xPos, :y => yPos, :letter => @letters[i][j] , :show_letters => options[:show_letters])
      end
    end
  end
end
