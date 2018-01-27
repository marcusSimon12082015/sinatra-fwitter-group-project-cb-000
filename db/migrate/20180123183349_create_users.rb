class CreateUsers < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'users'
      drop_table :users
    end
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
    end
  end
end
