# frozen_string_literal: true

require 'test_helper'

class CommandTest < ActiveSupport::TestCase
  let(:command) { commands :one }
  it 'validates size' do
    assert command.send(:size_valid?, '5 5')
    assert command.send(:size_valid?, '4 60000')
    refute command.send(:size_valid?, '4 test')
    refute command.send(:size_valid?, 5)
  end

  it 'validates starting position' do
    assert command.send(:rover_start_valid?, '1 2 N')
    assert command.send(:rover_start_valid?, '3 3 E')
    assert command.send(:rover_start_valid?, '4 60000 S')
    refute command.send(:rover_start_valid?, '4 test E')
    refute command.send(:rover_start_valid?, 5)
  end

  it 'validates rover commands' do
    assert command.send(:rover_command_valid?, 'LMLMLMLMM')
    assert command.send(:rover_command_valid?, 'MMRMMRMRRM')
    refute command.send(:rover_command_valid?, 'MLRLMS')
    refute command.send(:rover_command_valid?, 's')
    refute command.send(:rover_command_valid?, 5)
  end
end
