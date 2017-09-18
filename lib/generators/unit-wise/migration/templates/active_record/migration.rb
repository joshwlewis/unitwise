class UnitwiseMigration < ActiveRecord::Migration
  def self.up

    create_table :unitwise do |t|

      t.string :context

      t.datetime :created_at
    end

  end

  def self.down
    drop_table :unitwise
  end
end
