class CreateTweets < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'tweets'
      drop_table :tweets
    end
    create_table :tweets do |t|
      t.string :content
      t.integer :user_id
    end
  end
end
