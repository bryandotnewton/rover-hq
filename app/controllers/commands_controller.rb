class CommandsController < ApplicationController
  def index
    @command = Command.new
  end

  def show
    @command = Command.find(params[:id])
  end

  def new
    @command = Command.new
  end

  def create
    puts params
    puts 'create'
    command = Command.new(command_params)
    if command.save
      puts 'ok'
      redirect_to command_path(command)
    else
      puts 'not ok'
      render :index
    end
  rescue
    render :index
  end

  private

  def command_params
    params.require(:command).permit(:command_sheet)
  end
end
