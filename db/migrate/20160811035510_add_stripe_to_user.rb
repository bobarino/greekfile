class AddStripeToUser < ActiveRecord::Migration
  def change
     add_column :users, :stripe_cust_id, :string
     add_column :users, :active, :boolean
  end
end
