class DropPayolaTable < ActiveRecord::Migration
  def change
    drop_table :std_subscriptions
  end
end
