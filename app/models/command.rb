class Command < ApplicationRecord
  after_create_commit :process_commands

  has_one_attached :command_sheet
  has_one :grid
  has_many :rovers

  validates :command_sheets, presence: true
  # validate :validate_command_format

  private

  def process_commands
    size, command_list = parse_command_list
    create_grid x: size[0], y: size[1]
    command_list.each_slice(2).to_a.each do |commands|
      split_coords = commands[0].split
      rovers << rovers.create(
        start_x: split_coords[0].to_i,
        start_y: split_coords[1].to_i,
        start_direction: split_coords[2],
        commands: commands[1]
      )
    end
    rovers.each(&:process_commands)
  end

  def validate_command_format
    puts 'validate'
    size, command_list = parse_command_list
    puts 'lala'
    errors.add(:command_sheet, 'size is in an invalid format, must be \'X Y\'') unless size_valid?(size)
    command_list.each_slice(2).to_a.each_with_index do |commands|
      errors.add(:command_sheet, 'rover starting position is invalid, must be \'X Y <N E S W>\'') unless rover_start_valid?(commands[0])
      errors.add(:command_sheet, 'rover command is invalid, can only contain M L R') unless rover_command_valid?(commands[0])
    end
    puts 'errors?'
    puts errors
  end

  def size_valid?(size)
    return false unless size.is_a? String
    /\A\d+ \d+\Z/.match(size)
  end

  def rover_start_valid?(coords)
    return false unless coords.is_a? String
    /\A\d+ \d+ [NESW]\Z/.match(coords)
  end

  def rover_command_valid?(cmd)
    return false unless cmd.is_a? String
    /\A[MLR]+\Z/.match(cmd)
  end

  def parse_command_list
    puts 'parse'
    command_list = command_sheet.download.split("\n").map(&:strip)
    puts 'command_list'
    size = command_list.shift.split
    [size, command_list]
  end
end

