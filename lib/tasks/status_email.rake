namespace :email do
  desc "send email as per booking status"
  task send_email: :environment do
    time = Time.now.getlocal("+05:30").strftime "%H:%M"
    advance_time = (Time.now.getlocal("+05:30") + 5.minutes).strftime "%H:%M"
    today_date = Time.now.getlocal("+05:30").strftime "%d/%m/%Y"
    boardings = ApiDetail.where("booking_time >=? and booking_time <= ? and travel_date = ?",time,advance_time,today_date)
    boardings.each do |boarding|
      user = User.find(boarding.user_id)
      access_token = ENV["ACCESS_TOKEN"]
      base_uri = "https://sandbox-api.uber.com/v1/requests?access_token=#{access_token}"
      query = {
    	product_id: ENV["PRODUCT_ID"],
    	start_latitude: boarding.location_lat.to_f,
    	start_longitude: boarding.location_long.to_f,
    	end_latitude: boarding.station_lat.to_f,
    	end_longitude: boarding.station_long.to_f
        }.to_json

      headers = {'Content-Type' => 'application/json'}

      response = HTTParty.post(
        base_uri,
        :body => query,
        :headers => headers
        ).body
      status = # find status from response json
      # pnr = boarding.pnr
      pnr = 123 # need to change in Api_details table, add this column 
      SendEmail.send_uber_confirmation(user,status,pnr).deliver_now
    end
  end
end
