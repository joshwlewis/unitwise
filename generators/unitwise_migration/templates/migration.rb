class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :unitwise do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      t.column :tagger_id, :integer
      t.column :tagger_type, :string
      
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string
      t.column :context, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :unitwise, :tag_id
    add_index :unitwise, [:taggable_id, :taggable_type, :context]
  end
  
  def self.down
    drop_table :unitwise
  end
end