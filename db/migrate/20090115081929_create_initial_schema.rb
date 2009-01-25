class CreateInitialSchema < ActiveRecord::Migration
  def self.up
    create_table "groups", :force => true do |t|
      t.string :name
      t.timestamps
    end

    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.references :group, :null => false
    end
    add_index :users, :login, :unique => true
    add_index :users, :group_id

    create_table :developers do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :developers, :name, :unique => true

    create_table :computer_models do |t|
      t.timestamps
    end

    create_table :computer_assets do |t|
      t.references :developer
      t.string :model_number, :null => false
      t.string :product_name, :null => false
      t.references :group, :null => false
      t.string :asset_number
      t.timestamps
    end

    create_table :utilizations, :revision => true do |t|
      t.references :computer_asset, :null => false
      t.references :user
      t.references :group, :null => false
      t.text :description
      t.date :started_on
      t.integer :parent_id, :references => :utilizations
      t.timestamps
    end
    # TODO: extend create_table so that reviisons table is automaticaly created
#     create_table :utilization_revisions, :primary_key => false do |t|
#       t.integer :id, :null => false
#       t.integer :revision, :null => false
#       t.references :computer_asset, :user, :null => false
#       t.string :host_name
#       t.timestamps
#     end
#     add_index :utilization_revisions, [:id, :revision], :unique => true
  end

  def self.down
    drop_table :utilizations
    drop_table :computer_assets
    drop_table :computer_models
    drop_table :developers
    drop_table :users
    drop_table :groups
  end
end
