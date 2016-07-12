class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
	t.string :user_name
	t.string :email
    end
  end
end
