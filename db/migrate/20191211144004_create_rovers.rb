class CreateRovers < ActiveRecord::Migration[6.0]
  def change
    create_table :rovers do |t|
      t.integer :command_id, null: false
      t.string :name, null: false
      t.integer :start_x, null: false
      t.integer :start_y, null: false
      t.string :start_direction, null: false
      t.integer :end_x, default: nil
      t.integer :end_y, default: nil
      t.string :end_direction
      t.string :rover_errors
      t.string :commands, null: false
      t.timestamps
    end
  end
end
