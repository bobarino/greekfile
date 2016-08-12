class AddSubscriptionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_sub_id, :string
  end
end
