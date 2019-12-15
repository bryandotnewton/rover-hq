# frozen_string_literal: true

class Rover < ApplicationRecord
  attr_accessor :current_x, :current_y, :current_direction
  DIRECTIONS = %w[N E S W].freeze
  belongs_to :command

  def validate_rover
    command_set = commands.scan(/\w/)
    set_current_position
    command_set.each do |cmd|
      validate_command(cmd)
    end
    assign_attributes(
      end_x: @current_x,
      end_y: @current_y,
      end_direction: @current_direction
    )
  end

  def position
    x = end_x.present? ? end_x : start_x
    y = end_y.present? ? end_y : start_y
    [x, y]
  end

  private

  def set_current_position
    @current_x = start_x
    @current_y = start_y
    @current_direction = start_direction
  end

  def current_position
    [@current_x, @current_y]
  end

  def validate_command(cmd)
    process_command(cmd)
    if collision?
      errors.add(
        :base,
        "would collide with another rover at #{current_position}"
      )
    end
    errors.add :base, 'would fall off the plateau!' if out_of_bounds?
  end

  def process_command(cmd)
    case cmd.downcase
    when 'm'
      process_move
    when 'l'
      turn_left
    when 'r'
      turn_right
    end
  end

  def process_move
    case @current_direction
    when 'N'
      @current_y += 1
    when 'E'
      @current_x += 1
    when 'S'
      @current_y -= 1
    when 'W'
      @current_x -= 1
    end
  end

  def turn_right
    index = DIRECTIONS.index(@current_direction) + 1
    @current_direction = if index > DIRECTIONS.count - 1
                           DIRECTIONS[0]
                         else
                           DIRECTIONS[index]
                         end
  end

  def turn_left
    index = DIRECTIONS.index(@current_direction) - 1
    @current_direction = if index.negative?
                           DIRECTIONS[DIRECTIONS.length - 1]
                         else
                           DIRECTIONS[index]
                         end
  end

  def out_of_bounds?
    @current_x > command.grid.x ||
      @current_x.negative? ||
      @current_y > command.grid.y ||
      @current_y.negative?
  end

  def collision?
    other_rovers.each do |rov|
      return true if rov.position == current_position
    end
    false
  end

  def other_rovers
    command.rovers.reject do |rov|
      rov == self
    end
  end
end
