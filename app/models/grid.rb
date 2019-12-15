# frozen_string_literal: true

class Grid < ApplicationRecord
  belongs_to :command

  def draw_grid
    grid = []
    (y + 1).times do |_yy|
      col = []
      (x + 1).times do |_xx|
        col << 0
      end
      grid << col
    end
    grid
  end
end
