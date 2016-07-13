class CreateApiDetails < ActiveRecord::Migration
  def change
    create_table :api_details do |t|
	t.string :user_id  
      	t.string :pnr_number
	t.string :travel_date
	t.string :station_lat
	t.string :station_long
	t.text 	 :address
	t.string :location_lat
	t.string :location_long
  	t.string :booking_time
    end
  end
end
