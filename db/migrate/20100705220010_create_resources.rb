class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :url
      t.integer :request_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
