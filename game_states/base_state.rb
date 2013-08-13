class BaseState < Chingu::GameState 
  traits :timer

  def initialize(options = {})
    super

    @level = options[:level]
    @rows = options[:rows]
    @columns = options[:columns]

    for i in 1..@rows
      for j in 1..@columns
        xPos = j*90
        yPos = i*90

        Block.create(:x => xPos, :y => yPos, :show_letters => options[:show_letters])
      end
    end
  end

  def update
    super
  end
end
