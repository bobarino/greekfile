class CreateStdSubscription < ActiveRecord::Migration
  def change
    create_table :std_subscriptions do |t|
      t.string :permalink
      t.string :name
      t.string :price

      t.timestamps null: false
    end
  end
end
