require 'test_helper'

class RoverTest < ActiveSupport::TestCase
  let(:command) { commands :one }
  let(:grid) { grids :one }
  let(:rover) { rovers :one }
  # command.command_sheet.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'testfile.txt')), filename: 'testfile.txt', content_type: "text/plain")
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
    error = assert_raises(StandardError) do
      rover.process_commands
    end
    assert_equal 'Rover fell off the plateau!', error.message
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

  it 'processes commands' do
    rover.commands = 'MLMRM'
    expected = '1 4 N'
    rover.process_commands
    actual = "#{rover.end_x} #{rover.end_y} #{rover.end_direction}"
    assert_equal expected, actual
  end

  it 'collides' do
    rover2 = command.rovers.create(
      start_x: 2,
      start_y: 2,
      start_direction: 'N',
      commands: 'M'
    )
    assert rover.send(:collision?)
  end

  it 'does not collide' do
    rover2 = command.rovers.create(
      start_x: 2,
      start_y: 3,
      start_direction: 'N',
      commands: 'M'
    )
    refute rover.send(:collision?)
  end
end
