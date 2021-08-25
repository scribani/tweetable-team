class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :name
      t.integer :role, default: 0
      t.string :provider
      t.string :uid
      t.string :token

      t.timestamps
    end
    add_index :users, :token, unique: true
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :uid, unique: true
  end
end
