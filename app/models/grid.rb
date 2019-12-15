class Grid < ApplicationRecord
  belongs_to :command

  def draw_grid
    grid = []
    (y+1).times do |yy|
      col = []
      (x+1).times do |xx|
        col << 0
      end
      grid << col
    end
    return grid
  end
end
