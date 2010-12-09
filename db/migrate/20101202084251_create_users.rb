class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login_name, :string,:null => false
      t.column :password, :string,:null => false
      t.column :alias_name,:string,:null => false #别名
      t.column :email,:string ,:null => false#别名
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
