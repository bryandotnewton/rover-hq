class Command < ApplicationRecord
  # after_create_commit :process_commands

  has_one_attached :command_sheet
  has_one :grid
  has_many :rovers

  validate :validate_command
  # validates_associated :rovers, message: ->(_class_obj, obj){ obj[:value].errors.full_messages.join(',') }
  # validates_associated_bubbling :rovers
  validates_presence_of :rovers

  def initialize(args)
    super
    if command_sheet.present?
      build_commands
    end
  end

  private

  def build_commands
    puts 'build commands'
    self.size, self.command_list = parse_command_list(attachment_changes['command_sheet'].attachable.read)
    puts size
    puts command_list
    size_split = size.split
    build_grid(x: size_split[0], y: size_split[1])
    command_list.split("\n").each_slice(2).to_a.each_with_index do |commands, index|
      split_coords = commands[0].split
      puts 'BUILD'
      rovers.build(
        name: "rover-#{index}",
        start_x: split_coords[0].to_i,
        start_y: split_coords[1].to_i,
        start_direction: split_coords[2],
        commands: commands[1]
      )
    end
  end

  def process_commands
    # size, command_list = parse_command_list(command_sheet.download)
    size_split = size.split
    build_grid(x: size_split[0], y: size_split[1])
    command_list.each_slice(2).to_a.each do |commands|
      split_coords = commands[0].split
      rovers << rovers.build(
        start_x: split_coords[0].to_i,
        start_y: split_coords[1].to_i,
        start_direction: split_coords[2],
        commands: commands[1]
      )
    end
    # rovers.each(&:process_rover)
  end

  def validate_command
    puts 'validate command'
    errors.add :base, 'is empty' unless command_sheet.present?
    if command_sheet.attached?
      if command_sheet.blob.byte_size > 100000
        command_sheet.purge if command_sheet.blob.persisted?
        errors.add :base, 'is too big'
      elsif !command_sheet.blob.content_type.starts_with?('text/')
        puts command_sheet.blob.content_type
        command_sheet.purge if command_sheet.blob.persisted?
        errors.add :base, 'is in the wrong format'
      end
    end

    errors.add(:base, 'size is in an invalid format, must be \'X Y\'') unless size_valid?(size)
    command_list.split("\n").each_slice(2).to_a.each_with_index do |commands|
      errors.add(:base, 'rover starting position is invalid, must be \'X Y <N E S W>\'') unless rover_start_valid?(commands[0])
      errors.add(:base, 'rover command is invalid, can only contain M L R') unless rover_command_valid?(commands[1])
    end

    validate_rovers
  end

  def validate_rovers
    puts 'validate rovers'
    rovers.each do |rover|
      puts rover.inspect
      rover.validate_rover
      puts 'val'
      puts rover.errors.count
      rover.errors.full_messages.each do |msg|
        puts msg
        self.errors.add(:rover, msg)
        puts errors.full_messages
      end
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

