class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fsq_token
      t.string :c2g_token
      t.timestamps
    end
  end
end
