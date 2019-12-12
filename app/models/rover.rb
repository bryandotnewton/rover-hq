class Rover < ApplicationRecord
  DIRECTIONS = %w(N E S W)
  belongs_to :command

  def process_commands
    command_set = commands.scan /\w/
    @current_x = start_x
    @current_y = start_y
    @current_direction = start_direction
    @errors = []
    command_set.each do |com|
      process_command(com)
    end
    puts @current_x
    puts @current_y
    puts @current_direction
    update(
      end_x: @current_x,
      end_y: @current_y,
      end_direction: @current_direction,
      rover_errors: @errors.uniq.join(' || ')
    )
  end

  def current_position
    x = end_x.present? ? end_x : start_x
    y = end_y.present? ? end_y : start_y
    [x, y]
  end

  private

  def process_command(com)
    case com.downcase
    when 'm'
      move_rover
    when 'l'
      turn_left
    when 'r'
      turn_right
    end
  end

  def move_rover
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

    @errors << "Rover collided with another rover at #{current_position}" if collision?
    @errors << 'Rover fell off the plateau!' if out_of_bounds?
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
    command.rovers.where('id <> ?', id).map(&:current_position).any? do |coords|
      coords == current_position
    end
  end
end
