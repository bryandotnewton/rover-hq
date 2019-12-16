# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Command < ApplicationRecord
  has_one_attached :command_sheet
  has_one :grid
  has_many :rovers

  validate :validate_commands

  def initialize(args)
    super
    build_commands if command_sheet.present?
  end

  private

  def build_commands
    self.size, self.command_list = parse_command_list(
      attachment_changes['command_sheet'].attachable.read
    )
    size_split = size.split
    build_grid(x: size_split[0], y: size_split[1])
    build_rovers
  end

  def build_rovers
    command_list.split("\n").each_slice(2).to_a.each_with_index do |commands, index|
      x, y, direction = commands[0].split
      rovers.build(
        name: "rover-#{index}",
        start_x: x.to_i,
        start_y: y.to_i,
        start_direction: direction,
        commands: commands[1]
      )
    end
  end

  def validate_commands
    %w[validate_command_sheet_present validate_command_file validate_command_init validate_rovers].each do |mthd|
      send(mthd)
      break if errors.any?
    end
  end

  def validate_command_sheet_present
    errors.add :base, 'Command Sheet is empty' unless command_sheet.present?
  end

  def validate_command_file
    return unless command_sheet.attached? || errors.any?

    validate_file_size
    validate_file_type
  end

  def validate_file_size
    if command_sheet.blob.byte_size > 100_000
      command_sheet.purge if command_sheet.blob.persisted?
      errors.add :base, 'is too big'
    end
  end

  def validate_file_type
    unless command_sheet.blob.content_type.starts_with?('text/')
      command_sheet.purge if command_sheet.blob.persisted?
      errors.add :base, 'Command Sheet must be a text file'
    end
  end

  def validate_command_init
    validate_command_list_size
    validate_size
    validate_command_format
  end

  def validate_command_list_size
    if command_list.split("\n").each_slice(2).to_a.count > 10
      errors.add(
        :base,
        'Command Sheet specifies too many rovers, we only have 10!'
      )
    end
  end

  def validate_command_format
    command_list.split("\n").each_slice(2).to_a.each do |commands|
      errors.add(
        :base,
        'rover starting position is invalid, must be \'X Y <N E S W>\''
      ) unless rover_start_valid?(commands[0])

      errors.add(
        :base,
        'rover command is invalid, can only contain M L R'
      ) unless rover_command_valid?(commands[1])
    end
  end

  def validate_rovers
    rovers.each do |rover|
      rover.validate_rover
      rover.errors.full_messages.each do |msg|
        errors.add(:rover, msg)
      end
    end
  end

  def validate_size
    unless size_valid?(size)
      errors.add(
        :base,
        'size is in an invalid format, must be \'X Y\''
      )
    end
  end

  def size_valid?(size)
    return false unless size.is_a? String

    /^\d+ \d+$/.match(size).present?
  end

  def rover_start_valid?(coords)
    return false unless coords.is_a? String

    /^\d+ \d+ [NESW]$/.match(coords).present?
  end

  def rover_command_valid?(cmd)
    return false unless cmd.is_a? String

    /^[MLR]+$/.match(cmd).present?
  end

  def parse_command_list(commands)
    command_list = commands.split("\n").map(&:strip)
    size = command_list.shift
    [size, command_list.join("\n")]
  end
end
# rubocop:enable Metrics/ClassLength
