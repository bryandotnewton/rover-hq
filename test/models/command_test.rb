# frozen_string_literal: true

require 'test_helper'

class CommandTest < ActiveSupport::TestCase

  def test_command_list
      "2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M
      2 2 N
      M"
  end
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

  it 'validates rover commands size' do
    command.stubs(:command_list).returns(test_command_list)
    command.send(:validate_command_list_size)
    assert command.errors.none?
  end

  it 'validates rover commands size' do
    list = "#{test_command_list} 2 2 N\nM"
    command.stubs(:command_list).returns(list)
    command.send(:validate_command_list_size)
    assert command.errors.one?
  end

  it 'validates command format' do
    command_list = "1 2 E\nM"
    command.stubs(:command_list).returns(command_list)
    command.send(:validate_command_format)
    assert command.errors.none?
  end

  it 'validates command format' do
    command_list = "1 E E\nM"
    command.stubs(:command_list).returns(command_list)
    command.send(:validate_command_format)
    assert command.errors.first[1] == 'rover starting position is invalid, must be \'X Y <N E S W>\''
  end

  it 'validates command format' do
    command_list = "1 2 E\nG"
    command.stubs(:command_list).returns(command_list)
    command.send(:validate_command_format)
    assert command.errors.first[1] == 'rover command is invalid, can only contain M L R'
  end
end
