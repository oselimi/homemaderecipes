class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :handle_name
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
    add_index :users, :handle_name, unique: true
    add_index :users, :email, unique: true
  end
end
