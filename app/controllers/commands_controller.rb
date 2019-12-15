class CommandsController < ApplicationController
  def index
    @command ||= Command.new
  end

  def show
    @command = Command.find(params[:id])
    @rovers = {}
    @command.rovers.each_with_index do |rover, index|
      @rovers[index.to_s] = {
        "start_x" => rover.start_x,
        "start_y" => rover.start_y,
        "start_direction" => rover.start_direction,
        "commands" => rover.commands
      }
    end
  end

  def new
    @command = Command.new
  end

  def create
    @command = params[:command].present? ? Command.new(command_params) : Command.new
    if @command.save
      redirect_to command_path(@command)
    else
      render_error(@command.errors.full_messages)
    end
  rescue => e
    render_error([e.message])
  end

  private

  def render_error(errors)
    @command = Command.new
    errors.each do |err|
      @command.errors.add :base, err
    end
    render :index
  end

  def command_params
    params.require(:command).permit(:command_sheet, :size, :command_list)
  end
end
