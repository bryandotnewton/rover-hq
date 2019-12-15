# frozen_string_literal: true

class CreateGrids < ActiveRecord::Migration[6.0]
  def change
    create_table :grids do |t|
      t.integer :command_id, null: false
      t.integer :x, null: false
      t.integer :y, null: false
      t.timestamps
    end
  end
end
