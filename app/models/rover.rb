class Rover < ApplicationRecord
  attr_accessor :current_x, :current_y, :current_direction
  DIRECTIONS = %w(N E S W)
  belongs_to :command

  def process_rover
    process_commands
    update(
      end_x: @current_x,
      end_y: @current_y,
      end_direction: @current_direction
    )
  end

  def validate_rover
    command_set = commands.scan /\w/
    @current_x = start_x
    @current_y = start_y
    @current_direction = start_direction
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

  def current_position
    [@current_x, @current_y]
  end

  def process_commands
    command_set = commands.scan /\w/
    @current_x = start_x
    @current_y = start_y
    @current_direction = start_direction
    command_set.each do |cmd|
      process_command(cmd)
      break if errors.any?
    end
  end

  def validate_command(cmd)
    process_command(cmd)
    if collision?
      errors.add :base, "collided with another rover at #{current_position}"
    end
    errors.add :base, "fell off the plateau!" if out_of_bounds?
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
    @current_direction = index > DIRECTIONS.count - 1 ? DIRECTIONS[0] : DIRECTIONS[index]
  end

  def turn_left
    index = DIRECTIONS.index(@current_direction) - 1
    @current_direction = index < 0 ? DIRECTIONS[DIRECTIONS.length - 1] : DIRECTIONS[index]
  end

  def out_of_bounds?
    @current_x > command.grid.x || @current_x < 0 || @current_y > command.grid.y || @current_y < 0
  end

  def collision?
    other_rovers.each do |rov|
      return true if rov.position == [@current_x, @current_y]
    end
    false
  end

  def other_rovers
    command.rovers.reject do |rov|
      rov == self
    end
  end
end
