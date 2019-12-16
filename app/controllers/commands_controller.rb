# frozen_string_literal: true

class CommandsController < ApplicationController
  def show
    @command = Command.find(params[:id])
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
  rescue StandardError => e
    render_error([e.message])
  end

  private

  def render_error(errors)
    @command = Command.new
    errors.each do |err|
      flash[:error] = err
    end
    redirect_to root_path
  end

  def command_params
    params.require(:command).permit(:command_sheet, :size, :command_list)
  end
end
