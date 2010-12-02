class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login_name, :string
      t.column :password, :string
      t.column :alias_name,:string #别名
      t.column :email,:string #别名
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
