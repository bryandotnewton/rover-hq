# frozen_string_literal: true

require 'test_helper'

class RoverTest < ActiveSupport::TestCase
  let(:command) { commands :one }
  let(:grid) { grids :one }
  let(:rover) { rovers :one }
  it 'moves rover' do
    test_command = 'M'
    mock = MiniTest::Mock.new
    mock.expect(:call, :process_move)
    rover.stub(:process_move, mock) do
      rover.send(:process_command, test_command)
    end
    mock.verify
  end

  it 'registers out of bounds' do
    rover.start_y = 0
    rover.start_direction = 'S'
    rover.commands = 'M'
    rover.validate_rover
    assert_equal 'would fall off the plateau!', rover.errors.full_messages.first
  end

  it 'turns rover right' do
    test_command = 'R'
    mock = MiniTest::Mock.new
    mock.expect(:call, :process_move)
    rover.stub(:turn_right, mock) do
      rover.send(:process_command, test_command)
    end
    mock.verify
  end

  it 'turns rover right' do
    test_command = 'L'
    mock = MiniTest::Mock.new
    mock.expect(:call, :process_move)
    rover.stub(:turn_left, mock) do
      rover.send(:process_command, test_command)
    end
    mock.verify
  end

  it 'sets end position' do
    expected = '1 3 N'
    rover.validate_rover
    actual = "#{rover.end_x} #{rover.end_y} #{rover.end_direction}"
    assert_equal expected, actual
  end

  it 'collides' do
    rover2 = command.rovers.create(
      start_x: 1,
      start_y: 2,
      start_direction: 'N',
      commands: 'M',
      name: 'rover-5'
    )
    rover2.send(:set_current_position)
    assert rover2.send(:collision?)
  end

  it 'does not collide' do
    rover2 = command.rovers.create(
      start_x: 2,
      start_y: 3,
      start_direction: 'N',
      commands: 'M',
      name: 'rover-5'
    )
    refute rover2.send(:collision?)
  end
end
