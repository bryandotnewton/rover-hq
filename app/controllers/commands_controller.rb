class CommandsController < ApplicationController
  def index
    @commands = Command.all
  end

  def show
    @command = Command.find(params[:id])
  end

  def new
    @command = Command.new
  end

  def create
    puts 'create'
    puts command_params
    command = Command.create!(command_params)
    redirect_to command_path(command)
  end

  private

  # def parse_commands(command)
  #   puts 'parse'
  #   puts command.command_sheet
  #   file_path = command.command_sheet
  #   puts CSV.parse(file_path)

  #   # puts command_sheet.download.split("\n").map(&:strip)
  #   # grid = Grid.new *command_list.shift.split

  #   # rover_commands = command_list.each_slice(2).to_a

  #   # rover_commands.each do |commands|
  #   #   process_rover(commands)
  #   # end
  # end

  def command_params
    params.require(:command).permit(:command_sheet)
  end
end
